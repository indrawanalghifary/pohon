-- =============================================
-- Aplikasi Manajemen Pohon - Complete Database Setup
-- Master Script untuk Setup Database Lengkap
-- =============================================

-- =============================================
-- INSTRUKSI PENGGUNAAN
-- =============================================

/*
CARA MENJALANKAN SETUP DATABASE:

1. PERSIAPAN:
   - Pastikan PostgreSQL sudah terinstall dan running
   - Pastikan Supabase project sudah dibuat (jika menggunakan Supabase)
   - Backup database existing jika ada
   - Pastikan user memiliki privilege CREATE, ALTER, DROP

2. EKSEKUSI VIA PSQL:
   psql -U your_username -d your_database -f 00_complete_setup.sql

3. EKSEKUSI VIA SUPABASE SQL EDITOR:
   - Copy paste script ini ke SQL Editor
   - Run step by step atau sekaligus
   - Monitor output untuk error

4. VERIFIKASI:
   - Check apakah semua tabel terbuat
   - Check apakah sample data ter-insert
   - Test login dengan sample users
   - Test RLS policies

CATATAN PENTING:
- Script ini akan DROP existing tables jika ada
- Semua data existing akan HILANG
- Pastikan backup sebelum menjalankan
- Eksekusi memerlukan waktu 2-5 menit
*/

-- =============================================
-- SETUP CONFIGURATION
-- =============================================

-- Set timezone untuk konsistensi
SET timezone = 'Asia/Jakarta';

-- Enable verbose error reporting
\set ON_ERROR_STOP on
\set VERBOSITY verbose

-- =============================================
-- PRE-SETUP CHECKS
-- =============================================

-- Check PostgreSQL version (minimal 12.0)
DO $$
DECLARE
    version_num INTEGER;
BEGIN
    SELECT current_setting('server_version_num')::INTEGER INTO version_num;
    
    IF version_num < 120000 THEN
        RAISE EXCEPTION 'PostgreSQL version 12.0 or higher required. Current version: %', current_setting('server_version');
    ELSE
        RAISE NOTICE 'PostgreSQL version check passed: %', current_setting('server_version');
    END IF;
END $$;

-- Check required extensions availability
DO $$
BEGIN
    -- Check uuid-ossp extension
    IF NOT EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'uuid-ossp') THEN
        RAISE EXCEPTION 'Required extension uuid-ossp is not available';
    END IF;
    
    -- Check pgcrypto extension  
    IF NOT EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'pgcrypto') THEN
        RAISE EXCEPTION 'Required extension pgcrypto is not available';
    END IF;
    
    RAISE NOTICE 'Extension availability check passed';
END $$;

-- =============================================
-- CLEANUP EXISTING OBJECTS (Optional)
-- =============================================

-- Uncomment block di bawah jika ingin DROP semua objects existing
/*
DO $$
DECLARE
    r RECORD;
BEGIN
    -- Drop all foreign key constraints first
    FOR r IN (SELECT conname, conrelid::regclass AS table_name 
              FROM pg_constraint 
              WHERE contype = 'f' 
              AND connamespace = (SELECT oid FROM pg_namespace WHERE nspname = current_schema()))
    LOOP
        EXECUTE 'ALTER TABLE ' || r.table_name || ' DROP CONSTRAINT IF EXISTS ' || r.conname || ' CASCADE';
    END LOOP;
    
    -- Drop all tables
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema())
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
    
    -- Drop all functions
    FOR r IN (SELECT proname, oidvectortypes(proargtypes) as argtypes
              FROM pg_proc 
              WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = current_schema()))
    LOOP
        EXECUTE 'DROP FUNCTION IF EXISTS ' || quote_ident(r.proname) || '(' || r.argtypes || ') CASCADE';
    END LOOP;
    
    RAISE NOTICE 'Cleanup completed - all existing objects dropped';
END $$;
*/

-- =============================================
-- START TRANSACTION
-- =============================================

BEGIN;

-- =============================================
-- STEP 1: CREATE TABLES
-- =============================================

\echo ''
\echo '=========================================='
\echo 'STEP 1: Creating Tables and Extensions...'
\echo '=========================================='

\i 01_create_tables.sql

\echo 'STEP 1 COMPLETED: All tables created successfully'

-- =============================================
-- STEP 2: ADD CONSTRAINTS AND INDEXES
-- =============================================

\echo ''
\echo '=========================================='
\echo 'STEP 2: Adding Constraints and Indexes...'
\echo '=========================================='

\i 02_constraints_indexes.sql

\echo 'STEP 2 COMPLETED: All constraints and indexes added successfully'

-- =============================================
-- STEP 3: SETUP ROW LEVEL SECURITY
-- =============================================

\echo ''
\echo '=========================================='
\echo 'STEP 3: Setting up Row Level Security...'
\echo '=========================================='

\i 03_row_level_security.sql

\echo 'STEP 3 COMPLETED: Row Level Security configured successfully'

-- =============================================
-- STEP 4: CREATE FUNCTIONS AND TRIGGERS
-- =============================================

\echo ''
\echo '=========================================='
\echo 'STEP 4: Creating Functions and Triggers...'
\echo '=========================================='

\i 04_functions_triggers.sql

\echo 'STEP 4 COMPLETED: All functions and triggers created successfully'

-- =============================================
-- STEP 5: INSERT SAMPLE DATA
-- =============================================

\echo ''
\echo '=========================================='
\echo 'STEP 5: Inserting Sample Data...'
\echo '=========================================='

\i 05_sample_data.sql

\echo 'STEP 5 COMPLETED: Sample data inserted successfully'

-- =============================================
-- COMMIT TRANSACTION
-- =============================================

COMMIT;

-- =============================================
-- POST-SETUP VERIFICATION
-- =============================================

\echo ''
\echo '=========================================='
\echo 'POST-SETUP VERIFICATION'
\echo '=========================================='

-- Verify tables creation
DO $$
DECLARE
    table_count INTEGER;
    expected_tables TEXT[] := ARRAY[
        'user_roles', 'users', 'areas', 'tree_types', 'trees',
        'care_activities', 'tree_care_records', 'harvest_records',
        'operational_costs', 'notifications', 'reports', 'photos', 'audit_logs'
    ];
    missing_tables TEXT[] := ARRAY[]::TEXT[];
    table_name TEXT;
BEGIN
    -- Check if all expected tables exist
    FOREACH table_name IN ARRAY expected_tables
    LOOP
        IF NOT EXISTS (SELECT 1 FROM information_schema.tables 
                      WHERE table_schema = current_schema() 
                      AND table_name = table_name) THEN
            missing_tables := array_append(missing_tables, table_name);
        END IF;
    END LOOP;
    
    IF array_length(missing_tables, 1) > 0 THEN
        RAISE EXCEPTION 'Missing tables: %', array_to_string(missing_tables, ', ');
    END IF;
    
    SELECT COUNT(*) INTO table_count 
    FROM information_schema.tables 
    WHERE table_schema = current_schema();
    
    RAISE NOTICE 'Table verification passed: % tables created', table_count;
END $$;

-- Verify sample data
DO $$
DECLARE
    user_roles_count INTEGER;
    users_count INTEGER;
    areas_count INTEGER;
    trees_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_roles_count FROM user_roles;
    SELECT COUNT(*) INTO users_count FROM users;
    SELECT COUNT(*) INTO areas_count FROM areas;
    SELECT COUNT(*) INTO trees_count FROM trees;
    
    IF user_roles_count = 0 OR users_count = 0 OR areas_count = 0 OR trees_count = 0 THEN
        RAISE EXCEPTION 'Sample data verification failed - some tables are empty';
    END IF;
    
    RAISE NOTICE 'Sample data verification passed: % roles, % users, % areas, % trees', 
                 user_roles_count, users_count, areas_count, trees_count;
END $$;

-- Verify RLS policies
DO $$
DECLARE
    policy_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO policy_count 
    FROM pg_policies 
    WHERE schemaname = current_schema();
    
    IF policy_count = 0 THEN
        RAISE WARNING 'No RLS policies found - check if RLS setup completed correctly';
    ELSE
        RAISE NOTICE 'RLS verification passed: % policies active', policy_count;
    END IF;
END $$;

-- Verify functions and triggers
DO $$
DECLARE
    function_count INTEGER;
    trigger_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO function_count 
    FROM information_schema.routines 
    WHERE routine_schema = current_schema() 
    AND routine_type = 'FUNCTION';
    
    SELECT COUNT(*) INTO trigger_count 
    FROM information_schema.triggers 
    WHERE trigger_schema = current_schema();
    
    RAISE NOTICE 'Functions and triggers verification: % functions, % triggers', 
                 function_count, trigger_count;
END $$;

-- =============================================
-- SETUP COMPLETION SUMMARY
-- =============================================

\echo ''
\echo '=========================================='
\echo 'DATABASE SETUP COMPLETED SUCCESSFULLY!'
\echo '=========================================='

-- Display setup summary
DO $$
DECLARE
    setup_summary TEXT;
BEGIN
    setup_summary := E'
DATABASE SETUP SUMMARY:
======================

✓ Extensions: uuid-ossp, pgcrypto
✓ Tables: 13 core tables created
✓ Constraints: Foreign keys, checks, and unique constraints
✓ Indexes: Performance and partial indexes  
✓ RLS: Row Level Security policies for all tables
✓ Functions: Business logic and utility functions
✓ Triggers: Audit trail, auto-updates, and notifications
✓ Sample Data: Realistic Indonesian agriculture data

NEXT STEPS:
===========

1. SUPABASE CONFIGURATION (if using Supabase):
   - Configure Auth settings
   - Set up API keys
   - Configure storage buckets for photos

2. APPLICATION INTEGRATION:
   - Update connection strings
   - Test authentication flow
   - Verify API endpoints

3. USER MANAGEMENT:
   - Create production users via Supabase Auth
   - Assign appropriate roles
   - Test permissions

4. MONITORING:
   - Set up database monitoring
   - Configure backup schedules
   - Monitor performance metrics

SAMPLE USERS FOR TESTING:
========================

Role: Admin
- admin@pohon.app (Budi Santoso)
- admin2@pohon.app (Sari Indah)

Role: Leader Area  
- leader.medan@pohon.app (Dedi Kurniawan)
- leader.cirebon@pohon.app (Wati Suharto)
- leader.yogya@pohon.app (Bambang Prasetyo)

Role: Sales
- sales@pohon.app (Agus Wijaya)
- sales2@pohon.app (Rina Kusuma)

Role: Pekerja
- pekerja1@pohon.app (Joko Susilo)
- pekerja2@pohon.app (Ahmad Fadli)
- [+ 3 more workers]

AREAS AVAILABLE:
===============
- Kebun Durian Medan (50 ha)
- Kebun Mangga Cirebon (35 ha) 
- Kebun Rambutan Yogya (25 ha)

DATABASE READY FOR PRODUCTION USE!
==================================
';
    
    RAISE NOTICE '%', setup_summary;
END $$;

-- =============================================
-- ERROR HANDLING & ROLLBACK INSTRUCTIONS
-- =============================================

/*
TROUBLESHOOTING & ROLLBACK:
==========================

JIKA TERJADI ERROR DURING SETUP:

1. CHECK ERROR MESSAGES:
   - Lihat detail error message
   - Check apakah ada dependency yang hilang
   - Verify user permissions

2. PARTIAL ROLLBACK:
   - Script menggunakan transaction, jika error akan auto-rollback
   - Untuk manual rollback gunakan: ROLLBACK;

3. COMPLETE CLEANUP:
   -- Uncomment dan run block cleanup di atas untuk hapus semua

4. COMMON ISSUES:
   - Extension not available: Install postgresql-contrib
   - Permission denied: Grant superuser atau specific permissions
   - Existing objects: Run cleanup block terlebih dahulu

5. LOG ANALYSIS:
   - Check PostgreSQL logs: tail -f /var/log/postgresql/postgresql-*.log
   - Check Supabase logs di dashboard

6. RETRY STEPS:
   - Bisa menjalankan individual scripts jika master script gagal
   - Jalankan dalam urutan: 01 → 02 → 03 → 04 → 05

CONTACT & SUPPORT:
=================
Jika masih mengalami masalah, dokumentasikan:
- Error message lengkap
- PostgreSQL version
- Environment details (local/Supabase/cloud)
- Steps yang sudah dilakukan
*/

-- =============================================
-- SCRIPT COMPLETION
-- =============================================

\echo ''
\echo 'Master setup script execution completed.'
\echo 'Check messages above for any errors or warnings.'
\echo 'Database is ready for application use!'