# Database Aplikasi Manajemen Pohon

## 📋 Daftar Isi

- [Gambaran Umum](#gambaran-umum)
- [Struktur Database](#struktur-database)
- [Instalasi dan Setup](#instalasi-dan-setup)
- [Deskripsi File SQL](#deskripsi-file-sql)
- [Panduan Penggunaan](#panduan-penggunaan)
- [Query Examples](#query-examples)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)

## 🌳 Gambaran Umum

Aplikasi Manajemen Pohon adalah sistem informasi untuk mengelola perkebunan dengan fitur:

- **Manajemen Area**: Pengelolaan lahan perkebunan
- **Manajemen Pohon**: Tracking individual pohon dengan barcode
- **Perawatan**: Jadwal dan record aktivitas perawatan
- **Panen**: Recording hasil panen dan nilai ekonomi
- **Biaya Operasional**: Tracking biaya operasional
- **Laporan**: Generate laporan produktivitas dan analisis
- **Notifikasi**: System reminder dan alert otomatis
- **Audit Trail**: Complete logging semua aktivitas

### Teknologi Stack

- **Database**: PostgreSQL 12+ dengan Supabase
- **Authentication**: Supabase Auth
- **Security**: Row Level Security (RLS)
- **Extensions**: uuid-ossp, pgcrypto

## 🗄️ Struktur Database

### Core Tables

| Tabel | Deskripsi | Records |
|-------|-----------|---------|
| `user_roles` | Role pengguna sistem | 4 roles |
| `users` | Data pengguna (extends Supabase Auth) | 12 users |
| `areas` | Area/lahan perkebunan | 3 areas |
| `tree_types` | Master jenis pohon | 7 types |
| `trees` | Data individual pohon | 10 trees |
| `care_activities` | Master aktivitas perawatan | 7 activities |

### Transaction Tables

| Tabel | Deskripsi | Sample Records |
|-------|-----------|----------------|
| `tree_care_records` | Record perawatan pohon | 7 records |
| `harvest_records` | Record hasil panen | 4 records |
| `operational_costs` | Biaya operasional | 6 records |
| `notifications` | Sistem notifikasi | 6 notifications |
| `reports` | Laporan sistem | 2 reports |
| `photos` | Dokumentasi foto | - |
| `audit_logs` | Log audit aktivitas | Auto-generated |

### Database Schema Diagram

```
user_roles ──┐
             ├── users ──┐
             └── areas ──┤
                        ├── trees ──┬── tree_care_records
tree_types ──────────────┘         ├── harvest_records
                                   └── photos
care_activities ────────────────────┘
```

## 🚀 Instalasi dan Setup

### Persyaratan Sistem

- PostgreSQL 12.0+
- Supabase account (opsional)
- Extensions: `uuid-ossp`, `pgcrypto`
- Memory: minimal 4GB RAM
- Storage: minimal 10GB free space

### Quick Start

1. **Setup Database**
   ```bash
   # Via psql
   psql -U your_username -d your_database -f 00_complete_setup.sql
   
   # Atau via Supabase SQL Editor
   # Copy-paste content dari 00_complete_setup.sql
   ```

2. **Verifikasi Setup**
   ```sql
   -- Check tables
   SELECT count(*) FROM information_schema.tables 
   WHERE table_schema = 'public';
   
   -- Check sample data
   SELECT count(*) FROM users;
   SELECT count(*) FROM trees;
   ```

3. **Test Authentication**
   ```sql
   -- Test RLS function
   SELECT auth.user_role();
   ```

### Manual Setup (Step by Step)

Jika master script gagal, jalankan file individual:

```bash
# 1. Create tables and extensions
psql -f 01_create_tables.sql

# 2. Add constraints and indexes  
psql -f 02_constraints_indexes.sql

# 3. Setup Row Level Security
psql -f 03_row_level_security.sql

# 4. Create functions and triggers
psql -f 04_functions_triggers.sql

# 5. Insert sample data
psql -f 05_sample_data.sql
```

## 📝 Deskripsi File SQL

### [`01_create_tables.sql`](01_create_tables.sql:1)
**Database Tables Creation**

- Membuat 13 tabel utama
- Definisi kolom dengan tipe data optimal
- Primary keys menggunakan UUID
- Timestamps untuk audit trail
- JSONB untuk data flexible
- CHECK constraints untuk validasi

**Key Features:**
- UUID sebagai primary key
- Timestamped records (`created_at`, `updated_at`)
- JSONB untuk coordinates dan metadata
- Enum-like constraints untuk status

### [`02_constraints_indexes.sql`](02_constraints_indexes.sql:1)
**Constraints & Performance Optimization**

- Foreign key relationships
- Performance indexes (B-tree, GIN, partial)
- Check constraints untuk validasi
- Composite indexes untuk query optimization
- Unique constraints

**Index Strategy:**
- Single column indexes untuk filtering
- Composite indexes untuk joins
- Partial indexes untuk conditional queries
- GIN indexes untuk JSONB fields

### [`03_row_level_security.sql`](03_row_level_security.sql:1)
**Security & Access Control**

- RLS policies untuk semua tabel
- Helper functions untuk authorization
- Role-based access control
- Area-based data isolation

**Security Model:**
- **Admin**: Full access semua data
- **Leader Area**: Access area yang dikelola
- **Sales**: Read trees, manage harvest
- **Pekerja**: Access assigned trees only

### [`04_functions_triggers.sql`](04_functions_triggers.sql:1)
**Business Logic & Automation**

- 25+ custom functions
- Automated triggers
- Business logic enforcement
- Scheduled maintenance functions

**Key Functions:**
- `generate_tree_barcode()`: Auto barcode generation
- `calculate_tree_costs()`: Cost calculation
- `get_harvest_summary()`: Reporting functions
- `validate_*()`: Data validation functions

### [`05_sample_data.sql`](05_sample_data.sql:1)
**Realistic Sample Data**

- Data sample sesuai konteks Indonesia
- 3 area di Medan, Cirebon, Yogyakarta
- 7 jenis pohon buah lokal
- Complete workflow dari tanam hingga panen

**Sample Data Highlights:**
- Koordinat GPS real Indonesia
- Harga dalam Rupiah
- Nama pohon dan lokasi lokal
- Realistic timeline dan quantities

## 👨‍💻 Panduan Penggunaan

### Authentication & Authorization

```sql
-- Get current user role
SELECT auth.user_role();

-- Check if user is admin
SELECT auth.is_admin();

-- Get managed areas (for Leader Area)
SELECT auth.user_managed_areas();

-- Check area access
SELECT auth.has_area_access('area-uuid-here');
```

### User Management

```sql
-- Create new user role
INSERT INTO user_roles (name, description, permissions) 
VALUES ('Manager', 'Area Manager', '{"manage_area": true}');

-- Assign user to role
UPDATE users SET role_id = 'role-uuid' WHERE email = 'user@email.com';

-- List users by role
SELECT u.name, u.email, ur.name as role 
FROM users u 
JOIN user_roles ur ON u.role_id = ur.id;
```

### Tree Management

```sql
-- Add new tree (barcode auto-generated)
INSERT INTO trees (tree_type_id, area_id, planted_by, planting_date, coordinates)
VALUES ('tree-type-uuid', 'area-uuid', 'user-uuid', '2024-01-15', 
        '{"lat": -6.2088, "lng": 106.8456}');

-- Update tree status
UPDATE trees SET health_status = 'sick', notes = 'Needs attention'
WHERE tree_code = 'TRE-20240115-0001';

-- Get trees by area
SELECT t.tree_code, tt.name, t.health_status, t.growth_stage
FROM trees t
JOIN tree_types tt ON t.tree_type_id = tt.id
WHERE t.area_id = 'area-uuid';
```

### Care Management

```sql
-- Record care activity
INSERT INTO tree_care_records (tree_id, care_activity_id, performed_by, 
                               performed_at, duration_minutes, notes, cost_amount)
VALUES ('tree-uuid', 'activity-uuid', 'user-uuid', NOW(), 30, 
        'Routine watering completed', 15000);

-- Get overdue care activities
SELECT * FROM get_overdue_care_activities('area-uuid');

-- Check next care due date
SELECT calculate_next_care_due_date('tree-uuid', 'activity-uuid');
```

### Harvest Management

```sql
-- Record harvest
INSERT INTO harvest_records (tree_id, harvested_by, harvest_date, 
                             quantity, unit, market_price_per_unit, total_value)
VALUES ('tree-uuid', 'user-uuid', '2024-01-30', 50.5, 'kg', 25000, 1262500);

-- Get harvest summary
SELECT * FROM get_harvest_summary('area-uuid', '2024-01-01', '2024-01-31');

-- Calculate tree productivity
SELECT get_tree_productivity_rating('tree-uuid');
```

### Reporting

```sql
-- Generate automatic report
SELECT generate_automatic_report('monthly', 'area-uuid');

-- Get productivity analysis
SELECT * FROM analyze_productivity('area-uuid');

-- Calculate ROI
SELECT calculate_roi('area', 'area-uuid', '2023-01-01', '2024-01-01');
```

## 📊 Query Examples

### Dashboard Queries

```sql
-- Dashboard summary for area manager
WITH area_stats AS (
  SELECT 
    a.name as area_name,
    COUNT(t.id) as total_trees,
    COUNT(CASE WHEN t.health_status = 'healthy' THEN 1 END) as healthy_trees,
    COUNT(CASE WHEN t.health_status = 'sick' THEN 1 END) as sick_trees
  FROM areas a
  LEFT JOIN trees t ON a.id = t.area_id AND t.is_active = true
  WHERE a.manager_id = auth.uid()
  GROUP BY a.id, a.name
)
SELECT 
  area_name,
  total_trees,
  healthy_trees,
  sick_trees,
  ROUND((healthy_trees::decimal / NULLIF(total_trees, 0)) * 100, 1) as health_percentage
FROM area_stats;
```

```sql
-- Recent activities summary
SELECT 
  ca.name as activity,
  COUNT(*) as count,
  SUM(tcr.cost_amount) as total_cost,
  AVG(tcr.duration_minutes) as avg_duration
FROM tree_care_records tcr
JOIN care_activities ca ON tcr.care_activity_id = ca.id
JOIN trees t ON tcr.tree_id = t.id
WHERE tcr.performed_at >= CURRENT_DATE - INTERVAL '7 days'
  AND auth.has_area_access(t.area_id)
GROUP BY ca.id, ca.name
ORDER BY count DESC;
```

### Financial Queries

```sql
-- Monthly cost vs revenue analysis
WITH monthly_data AS (
  -- Revenue from harvest
  SELECT 
    DATE_TRUNC('month', hr.harvest_date) as month,
    SUM(hr.total_value) as revenue,
    0 as costs
  FROM harvest_records hr
  JOIN trees t ON hr.tree_id = t.id
  WHERE auth.has_area_access(t.area_id)
  
  UNION ALL
  
  -- Costs from operations
  SELECT 
    DATE_TRUNC('month', oc.date) as month,
    0 as revenue,
    SUM(oc.amount) as costs
  FROM operational_costs oc
  WHERE oc.status = 'paid'
    AND (oc.area_id IS NULL OR auth.has_area_access(oc.area_id))
    
  UNION ALL
  
  -- Costs from care activities
  SELECT 
    DATE_TRUNC('month', tcr.performed_at) as month,
    0 as revenue,
    SUM(tcr.cost_amount) as costs
  FROM tree_care_records tcr
  JOIN trees t ON tcr.tree_id = t.id
  WHERE auth.has_area_access(t.area_id)
)
SELECT 
  month,
  SUM(revenue) as total_revenue,
  SUM(costs) as total_costs,
  SUM(revenue) - SUM(costs) as profit,
  CASE 
    WHEN SUM(costs) > 0 THEN ROUND(((SUM(revenue) - SUM(costs)) / SUM(costs)) * 100, 2)
    ELSE NULL 
  END as roi_percentage
FROM monthly_data
GROUP BY month
ORDER BY month DESC;
```

### Performance Queries

```sql
-- Tree performance ranking
SELECT 
  t.tree_code,
  tt.name as tree_type,
  a.name as area,
  calculate_tree_age_months(t.planting_date) as age_months,
  COALESCE(SUM(hr.total_value), 0) as total_harvest_value,
  get_tree_productivity_rating(t.id) as productivity_rating
FROM trees t
JOIN tree_types tt ON t.tree_type_id = tt.id
JOIN areas a ON t.area_id = a.id
LEFT JOIN harvest_records hr ON t.id = hr.tree_id
WHERE t.is_active = true
  AND auth.has_area_access(t.area_id)
GROUP BY t.id, t.tree_code, tt.name, a.name, t.planting_date
ORDER BY total_harvest_value DESC;
```

### Maintenance Queries

```sql
-- Trees needing attention
SELECT 
  t.tree_code,
  t.health_status,
  t.notes,
  a.name as area,
  tt.name as tree_type,
  COALESCE(latest_care.performed_at, t.planting_date) as last_care,
  CURRENT_DATE - COALESCE(latest_care.performed_at::date, t.planting_date) as days_since_care
FROM trees t
JOIN areas a ON t.area_id = a.id
JOIN tree_types tt ON t.tree_type_id = tt.id
LEFT JOIN LATERAL (
  SELECT performed_at 
  FROM tree_care_records tcr 
  WHERE tcr.tree_id = t.id 
  ORDER BY performed_at DESC 
  LIMIT 1
) latest_care ON true
WHERE t.health_status IN ('sick', 'critical')
   OR (CURRENT_DATE - COALESCE(latest_care.performed_at::date, t.planting_date)) > 30
ORDER BY 
  CASE t.health_status 
    WHEN 'critical' THEN 1 
    WHEN 'sick' THEN 2 
    ELSE 3 
  END,
  days_since_care DESC;
```

## 🛠️ Troubleshooting

### Common Issues

#### 1. **Connection Errors**
```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Check connections
SELECT count(*) FROM pg_stat_activity;

# Reset connections
SELECT pg_terminate_backend(pid) FROM pg_stat_activity 
WHERE datname = 'your_database' AND state = 'idle';
```

#### 2. **Permission Errors**
```sql
-- Grant schema permissions
GRANT USAGE ON SCHEMA public TO your_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO your_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO your_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO your_user;
```

#### 3. **RLS Policy Issues**
```sql
-- Temporarily disable RLS for testing
ALTER TABLE table_name DISABLE ROW LEVEL SECURITY;

-- Check current user
SELECT current_user, auth.uid(), auth.user_role();

-- List all policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public';
```

#### 4. **Function Errors**
```sql
-- Check function definitions
SELECT proname, prosrc FROM pg_proc 
WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');

-- Drop and recreate problematic function
DROP FUNCTION IF EXISTS function_name CASCADE;
```

#### 5. **Data Validation Errors**
```sql
-- Check constraint violations
SELECT conname, conrelid::regclass 
FROM pg_constraint 
WHERE NOT convalidated;

-- Validate specific constraint
ALTER TABLE table_name VALIDATE CONSTRAINT constraint_name;
```

### Performance Issues

#### 1. **Slow Queries**
```sql
-- Enable query logging
SET log_statement = 'all';
SET log_min_duration_statement = 1000; -- Log queries > 1s

-- Analyze query performance
EXPLAIN (ANALYZE, BUFFERS) your_query_here;

-- Check index usage
SELECT schemaname, tablename, indexname, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_tup_read DESC;
```

#### 2. **Missing Indexes**
```sql
-- Find missing indexes
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE schemaname = 'public'
  AND n_distinct > 100
  AND abs(correlation) < 0.1;
```

#### 3. **Bloated Tables**
```sql
-- Check table sizes
SELECT nspname, relname, pg_size_pretty(pg_total_relation_size(C.oid))
FROM pg_class C
LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
WHERE nspname = 'public'
ORDER BY pg_total_relation_size(C.oid) DESC;

-- Vacuum analyze
VACUUM ANALYZE;
```

### Debug Tools

```sql
-- Check recent errors
SELECT * FROM pg_stat_database WHERE datname = current_database();

-- Monitor active queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

-- Check locks
SELECT t.relname, l.locktype, page, virtualtransaction, pid, mode, granted
FROM pg_locks l, pg_stat_all_tables t
WHERE l.relation = t.relid
ORDER BY relation ASC;
```

## 🔧 Maintenance

### Daily Tasks

```sql
-- 1. Check database health
SELECT count(*) as total_connections FROM pg_stat_activity;
SELECT pg_size_pretty(pg_database_size(current_database())) as db_size;

-- 2. Cleanup expired notifications (automated via trigger)
-- 3. Check failed operations
SELECT count(*) FROM operational_costs WHERE status = 'failed';

-- 4. Monitor growth
SELECT COUNT(*) as new_trees_today FROM trees 
WHERE planting_date = CURRENT_DATE;
```

### Weekly Tasks

```sql
-- 1. Update statistics
ANALYZE;

-- 2. Check overdue care activities
SELECT * FROM get_overdue_care_activities();

-- 3. Performance monitoring
SELECT * FROM pg_stat_user_tables 
WHERE schemaname = 'public' 
ORDER BY seq_tup_read + idx_tup_fetch DESC;

-- 4. Generate weekly reports (automated via function)
SELECT weekly_care_due_notifications();
```

### Monthly Tasks

```sql
-- 1. Vacuum tables
VACUUM ANALYZE;

-- 2. Reindex if needed
REINDEX DATABASE your_database;

-- 3. Archive old data (if applicable)
-- Move old audit_logs to archive table

-- 4. Update user statistics
UPDATE users SET last_login_at = NOW() 
WHERE id IN (SELECT DISTINCT user_id FROM audit_logs 
             WHERE created_at >= CURRENT_DATE - INTERVAL '30 days');

-- 5. Generate monthly reports (automated)
SELECT monthly_productivity_reports();
```

### Backup Strategy

```bash
# Daily backup
pg_dump -h localhost -U username -d database_name \
  --format=custom --no-owner --no-privileges \
  --file=backup_$(date +%Y%m%d).dump

# Restore from backup
pg_restore -h localhost -U username -d database_name \
  --clean --if-exists backup_20240115.dump

# Backup with compression
pg_dump database_name | gzip > backup_$(date +%Y%m%d).sql.gz
```

### Monitoring Queries

```sql
-- Database health dashboard
SELECT 
  current_database() as database,
  pg_size_pretty(pg_database_size(current_database())) as size,
  (SELECT count(*) FROM pg_stat_activity) as connections,
  (SELECT count(*) FROM trees WHERE is_active = true) as active_trees,
  (SELECT count(*) FROM users WHERE is_active = true) as active_users,
  (SELECT count(*) FROM tree_care_records WHERE performed_at::date = CURRENT_DATE) as todays_activities;
```

---

## 📞 Support & Contact

Untuk pertanyaan teknis atau bantuan implementasi:

1. **Database Issues**: Check troubleshooting section
2. **Performance Problems**: Analyze queries dengan EXPLAIN
3. **Security Concerns**: Review RLS policies
4. **Feature Requests**: Extend functions sesuai kebutuhan

**Best Practices:**
- Selalu backup sebelum perubahan major
- Test di environment development dulu
- Monitor performance secara regular
- Update statistics secara berkala
- Document custom modifications

---

*Database Aplikasi Manajemen Pohon v1.0*  
*Optimized for Indonesian Agriculture Context*