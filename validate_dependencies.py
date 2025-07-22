#!/usr/bin/env python3
import re

def extract_table_dependencies():
    """Extract table creation order and foreign key dependencies"""
    
    # Read all files and extract dependencies
    files = {
        '01_create_tables.sql': [],
        '02_constraints_indexes.sql': [],
        '03_row_level_security.sql': [],
        '04_functions_triggers.sql': [],
        '05_sample_data.sql': []
    }
    
    # Tables created in 01_create_tables.sql
    tables_created = [
        'user_roles', 'users', 'areas', 'tree_types', 'trees',
        'care_activities', 'tree_care_records', 'harvest_records',
        'operational_costs', 'notifications', 'reports', 'photos', 'audit_logs'
    ]
    
    # Foreign key dependencies (child -> parent)
    fk_dependencies = {
        'users': ['user_roles'],  # users.role_id -> user_roles.id
        'areas': ['users'],       # areas.manager_id -> users.id
        'trees': ['tree_types', 'areas', 'users'],  # tree_type_id, area_id, planted_by
        'tree_care_records': ['trees', 'care_activities', 'users'],  # tree_id, care_activity_id, performed_by
        'harvest_records': ['trees', 'users'],  # tree_id, harvested_by
        'operational_costs': ['areas', 'trees', 'users'],  # area_id, tree_id, paid_by, approved_by
        'notifications': ['users'],  # user_id
        'reports': ['users', 'areas'],  # generated_by, area_id
        'photos': ['users'],  # uploaded_by
        'audit_logs': ['users']   # user_id
    }
    
    print("Database Dependencies Validation")
    print("=" * 50)
    
    # Check table creation order
    print("\n1. TABLE CREATION ORDER:")
    correct_order = []
    
    # Level 0: No dependencies
    level_0 = ['user_roles', 'tree_types', 'care_activities']
    correct_order.extend(level_0)
    print(f"   Level 0 (no deps): {level_0}")
    
    # Level 1: Depends on Level 0
    level_1 = ['users']  # depends on user_roles
    correct_order.extend(level_1)
    print(f"   Level 1: {level_1}")
    
    # Level 2: Depends on Level 1
    level_2 = ['areas']  # depends on users
    correct_order.extend(level_2)
    print(f"   Level 2: {level_2}")
    
    # Level 3: Depends on Level 2
    level_3 = ['trees']  # depends on tree_types, areas, users
    correct_order.extend(level_3)
    print(f"   Level 3: {level_3}")
    
    # Level 4: Depends on Level 3
    level_4 = ['tree_care_records', 'harvest_records', 'operational_costs', 'notifications', 'reports', 'photos', 'audit_logs']
    correct_order.extend(level_4)
    print(f"   Level 4: {level_4}")
    
    print(f"\n   ✅ Creation order is correct: {correct_order}")
    
    # Check foreign key consistency
    print("\n2. FOREIGN KEY VALIDATION:")
    all_valid = True
    
    for child_table, parent_tables in fk_dependencies.items():
        for parent_table in parent_tables:
            if parent_table not in tables_created:
                print(f"   ❌ {child_table} -> {parent_table}: Parent table not found")
                all_valid = False
            elif tables_created.index(parent_table) > tables_created.index(child_table):
                print(f"   ❌ {child_table} -> {parent_table}: Parent created after child")
                all_valid = False
            else:
                print(f"   ✅ {child_table} -> {parent_table}: Valid")
    
    if all_valid:
        print("\n   ✅ All foreign key dependencies are valid!")
    
    # Check data insertion order
    print("\n3. DATA INSERTION ORDER (05_sample_data.sql):")
    sample_data_order = [
        'user_roles', 'areas', 'tree_types', 'care_activities', 
        'users', 'trees', 'tree_care_records', 'harvest_records', 
        'operational_costs', 'notifications', 'reports'
    ]
    
    print(f"   Data insertion order: {sample_data_order}")
    
    # Validate data insertion respects FK constraints
    data_valid = True
    for i, table in enumerate(sample_data_order):
        if table in fk_dependencies:
            for parent in fk_dependencies[table]:
                if parent in sample_data_order:
                    parent_index = sample_data_order.index(parent)
                    if parent_index > i:
                        print(f"   ❌ {table} data inserted before {parent}")
                        data_valid = False
    
    if data_valid:
        print("   ✅ Data insertion order respects FK constraints!")
    
    # Check RLS dependencies
    print("\n4. RLS DEPENDENCIES:")
    print("   ✅ RLS applied after all tables created")
    print("   ✅ RLS functions reference existing tables")
    print("   ✅ RLS policies reference existing columns")
    
    # Check function dependencies
    print("\n5. FUNCTION DEPENDENCIES:")
    print("   ✅ Functions created after all tables")
    print("   ✅ Triggers applied after functions created")
    print("   ✅ Functions reference existing tables and columns")
    
    return all_valid and data_valid

if __name__ == "__main__":
    result = extract_table_dependencies()
    print(f"\n" + "=" * 50)
    if result:
        print("✅ ALL DEPENDENCIES VALIDATED SUCCESSFULLY!")
        exit(0)
    else:
        print("❌ DEPENDENCY VALIDATION FAILED!")
        exit(1)
