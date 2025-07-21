-- =============================================
-- Aplikasi Manajemen Pohon - Row Level Security
-- =============================================

-- =============================================
-- Enable RLS pada semua tabel
-- =============================================

-- Enable RLS untuk tabel users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel areas
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel tree_types
ALTER TABLE tree_types ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel trees
ALTER TABLE trees ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel care_activities
ALTER TABLE care_activities ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel tree_care_records
ALTER TABLE tree_care_records ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel harvest_records
ALTER TABLE harvest_records ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel operational_costs
ALTER TABLE operational_costs ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel notifications
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel reports
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel photos
ALTER TABLE photos ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel audit_logs (khusus Admin saja)
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Enable RLS untuk tabel user_roles
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

-- =============================================
-- Helper Functions untuk RLS
-- =============================================

-- Function untuk mendapatkan role user saat ini
CREATE OR REPLACE FUNCTION auth.user_role()
RETURNS TEXT AS $$
DECLARE
  user_role_name TEXT;
BEGIN
  SELECT ur.name INTO user_role_name
  FROM users u
  JOIN user_roles ur ON u.role_id = ur.id
  WHERE u.id = auth.uid();
  
  RETURN COALESCE(user_role_name, 'guest');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function untuk mengecek apakah user adalah Admin
CREATE OR REPLACE FUNCTION auth.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN auth.user_role() = 'Admin';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function untuk mendapatkan area_id yang dikelola user
CREATE OR REPLACE FUNCTION auth.user_managed_areas()
RETURNS UUID[] AS $$
DECLARE
  managed_areas UUID[];
BEGIN
  -- Untuk Leader Area, ambil area yang mereka kelola
  IF auth.user_role() = 'Leader Area' THEN
    SELECT ARRAY_AGG(a.id) INTO managed_areas
    FROM areas a
    WHERE a.manager_id = auth.uid();
    
    RETURN COALESCE(managed_areas, ARRAY[]::UUID[]);
  END IF;
  
  -- Untuk role lain, return empty array
  RETURN ARRAY[]::UUID[];
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function untuk mengecek apakah user memiliki akses ke area tertentu
CREATE OR REPLACE FUNCTION auth.has_area_access(area_uuid UUID)
RETURNS BOOLEAN AS $$
BEGIN
  -- Admin memiliki akses ke semua area
  IF auth.is_admin() THEN
    RETURN TRUE;
  END IF;
  
  -- Leader Area hanya bisa akses area yang mereka kelola
  IF auth.user_role() = 'Leader Area' THEN
    RETURN area_uuid = ANY(auth.user_managed_areas());
  END IF;
  
  -- Sales bisa akses semua area untuk read
  IF auth.user_role() = 'Sales' THEN
    RETURN TRUE;
  END IF;
  
  -- Pekerja bisa akses area tempat mereka assigned
  IF auth.user_role() = 'Pekerja' THEN
    -- Check jika ada tree care record atau harvest record yang dibuat user di area tersebut
    RETURN EXISTS (
      SELECT 1 FROM trees t 
      WHERE t.area_id = area_uuid 
      AND (t.planted_by = auth.uid() OR EXISTS (
        SELECT 1 FROM tree_care_records tcr 
        WHERE tcr.tree_id = t.id AND tcr.performed_by = auth.uid()
      ))
    );
  END IF;
  
  RETURN FALSE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function untuk mengecek permission spesifik user
CREATE OR REPLACE FUNCTION auth.has_permission(permission_name TEXT)
RETURNS BOOLEAN AS $$
DECLARE
  user_permissions JSONB;
BEGIN
  SELECT ur.permissions INTO user_permissions
  FROM users u
  JOIN user_roles ur ON u.role_id = ur.id
  WHERE u.id = auth.uid();
  
  RETURN COALESCE((user_permissions->>permission_name)::BOOLEAN, FALSE);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================
-- RLS Policies - Admin (Full Access)
-- =============================================

-- Admin: Full access ke semua tabel
CREATE POLICY "admin_full_access_users" ON users FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_areas" ON areas FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_tree_types" ON tree_types FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_trees" ON trees FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_care_activities" ON care_activities FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_tree_care_records" ON tree_care_records FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_harvest_records" ON harvest_records FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_operational_costs" ON operational_costs FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_notifications" ON notifications FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_reports" ON reports FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_photos" ON photos FOR ALL TO authenticated 
USING (auth.is_admin());

CREATE POLICY "admin_full_access_user_roles" ON user_roles FOR ALL TO authenticated 
USING (auth.is_admin());

-- Audit logs hanya untuk Admin
CREATE POLICY "admin_only_audit_logs" ON audit_logs FOR ALL TO authenticated 
USING (auth.is_admin());

-- =============================================
-- RLS Policies - Leader Area
-- =============================================

-- Leader Area: Read access ke user_roles, tree_types, care_activities
CREATE POLICY "leader_read_user_roles" ON user_roles FOR SELECT TO authenticated 
USING (auth.user_role() = 'Leader Area');

CREATE POLICY "leader_read_tree_types" ON tree_types FOR SELECT TO authenticated 
USING (auth.user_role() = 'Leader Area');

CREATE POLICY "leader_read_care_activities" ON care_activities FOR SELECT TO authenticated 
USING (auth.user_role() = 'Leader Area');

-- Leader Area: Full access ke data dalam area yang mereka kelola
CREATE POLICY "leader_area_access_areas" ON areas FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND id = ANY(auth.user_managed_areas()));

CREATE POLICY "leader_area_access_trees" ON trees FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND auth.has_area_access(area_id));

CREATE POLICY "leader_area_access_tree_care_records" ON tree_care_records FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND EXISTS (
  SELECT 1 FROM trees t WHERE t.id = tree_id AND auth.has_area_access(t.area_id)
));

CREATE POLICY "leader_area_access_harvest_records" ON harvest_records FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND EXISTS (
  SELECT 1 FROM trees t WHERE t.id = tree_id AND auth.has_area_access(t.area_id)
));

CREATE POLICY "leader_area_access_operational_costs" ON operational_costs FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND (
  area_id = ANY(auth.user_managed_areas()) OR 
  (tree_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM trees t WHERE t.id = tree_id AND auth.has_area_access(t.area_id)
  ))
));

CREATE POLICY "leader_area_access_reports" ON reports FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND (
  area_id = ANY(auth.user_managed_areas()) OR area_id IS NULL
));

CREATE POLICY "leader_area_access_photos" ON photos FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND (
  (related_entity_type = 'area' AND related_entity_id = ANY(auth.user_managed_areas())) OR
  (related_entity_type = 'tree' AND EXISTS (
    SELECT 1 FROM trees t WHERE t.id = related_entity_id AND auth.has_area_access(t.area_id)
  )) OR
  (related_entity_type IN ('care_record', 'harvest_record') AND EXISTS (
    SELECT 1 FROM trees t 
    JOIN tree_care_records tcr ON tcr.tree_id = t.id 
    WHERE tcr.id = related_entity_id AND auth.has_area_access(t.area_id)
  ))
));

-- Leader Area: Access ke notifications untuk area atau role mereka
CREATE POLICY "leader_area_notifications" ON notifications FOR ALL TO authenticated 
USING (auth.user_role() = 'Leader Area' AND (
  user_id = auth.uid() OR 
  (related_entity_type = 'area' AND related_entity_id = ANY(auth.user_managed_areas()))
));

-- Leader Area: Access ke users dalam area mereka
CREATE POLICY "leader_area_users" ON users FOR SELECT TO authenticated 
USING (auth.user_role() = 'Leader Area' AND (
  id = auth.uid() OR 
  EXISTS (
    SELECT 1 FROM trees t WHERE t.planted_by = id AND auth.has_area_access(t.area_id)
  ) OR
  EXISTS (
    SELECT 1 FROM tree_care_records tcr 
    JOIN trees t ON t.id = tcr.tree_id 
    WHERE tcr.performed_by = id AND auth.has_area_access(t.area_id)
  )
));

-- =============================================
-- RLS Policies - Sales
-- =============================================

-- Sales: Read access ke trees, harvest_records, operational_costs
CREATE POLICY "sales_read_trees" ON trees FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales');

CREATE POLICY "sales_read_tree_types" ON tree_types FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales');

CREATE POLICY "sales_read_areas" ON areas FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales');

-- Sales: Write access ke harvest_records
CREATE POLICY "sales_access_harvest_records" ON harvest_records FOR ALL TO authenticated 
USING (auth.user_role() = 'Sales');

-- Sales: Read access ke operational_costs
CREATE POLICY "sales_read_operational_costs" ON operational_costs FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales');

-- Sales: Read access ke reports terkait harvest
CREATE POLICY "sales_read_reports" ON reports FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales' AND category IN ('harvest_report', 'cost_analysis'));

-- Sales: Read access ke photos harvest
CREATE POLICY "sales_read_photos" ON photos FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales' AND related_entity_type IN ('tree', 'harvest_record'));

-- Sales: Access ke notifications mereka
CREATE POLICY "sales_notifications" ON notifications FOR SELECT TO authenticated 
USING (auth.user_role() = 'Sales' AND user_id = auth.uid());

-- =============================================
-- RLS Policies - Pekerja
-- =============================================

-- Pekerja: Read access ke trees dalam area yang assigned
CREATE POLICY "pekerja_read_trees" ON trees FOR SELECT TO authenticated 
USING (auth.user_role() = 'Pekerja' AND auth.has_area_access(area_id));

-- Pekerja: Read access ke care_activities
CREATE POLICY "pekerja_read_care_activities" ON care_activities FOR SELECT TO authenticated 
USING (auth.user_role() = 'Pekerja');

-- Pekerja: Write access ke tree_care_records yang mereka buat
CREATE POLICY "pekerja_own_tree_care_records" ON tree_care_records FOR ALL TO authenticated 
USING (auth.user_role() = 'Pekerja' AND performed_by = auth.uid());

-- Pekerja: Read access ke tree_care_records untuk trees yang mereka handle
CREATE POLICY "pekerja_read_tree_care_records" ON tree_care_records FOR SELECT TO authenticated 
USING (auth.user_role() = 'Pekerja' AND EXISTS (
  SELECT 1 FROM trees t WHERE t.id = tree_id AND auth.has_area_access(t.area_id)
));

-- Pekerja: Write access ke harvest_records yang mereka buat
CREATE POLICY "pekerja_own_harvest_records" ON harvest_records FOR ALL TO authenticated 
USING (auth.user_role() = 'Pekerja' AND harvested_by = auth.uid());

-- Pekerja: Read access ke harvest_records untuk trees yang mereka handle
CREATE POLICY "pekerja_read_harvest_records" ON harvest_records FOR SELECT TO authenticated 
USING (auth.user_role() = 'Pekerja' AND EXISTS (
  SELECT 1 FROM trees t WHERE t.id = tree_id AND auth.has_area_access(t.area_id)
));

-- Pekerja: Limited access ke photos untuk pekerjaan mereka
CREATE POLICY "pekerja_work_photos" ON photos FOR ALL TO authenticated 
USING (auth.user_role() = 'Pekerja' AND (
  uploaded_by = auth.uid() OR 
  (related_entity_type = 'tree' AND EXISTS (
    SELECT 1 FROM trees t WHERE t.id = related_entity_id AND auth.has_area_access(t.area_id)
  )) OR
  (related_entity_type = 'care_record' AND EXISTS (
    SELECT 1 FROM tree_care_records tcr WHERE tcr.id = related_entity_id AND tcr.performed_by = auth.uid()
  )) OR
  (related_entity_type = 'harvest_record' AND EXISTS (
    SELECT 1 FROM harvest_records hr WHERE hr.id = related_entity_id AND hr.harvested_by = auth.uid()
  ))
));

-- Pekerja: Access ke notifications mereka
CREATE POLICY "pekerja_notifications" ON notifications FOR SELECT TO authenticated 
USING (auth.user_role() = 'Pekerja' AND user_id = auth.uid());

-- =============================================
-- Special Policies
-- =============================================

-- User dapat melihat dan edit profile sendiri
CREATE POLICY "users_own_profile" ON users FOR ALL TO authenticated 
USING (id = auth.uid());

-- Notifications dapat dilihat oleh target user
CREATE POLICY "user_own_notifications" ON notifications FOR SELECT TO authenticated 
USING (user_id = auth.uid());

-- Notifications dapat diupdate (mark as read) oleh target user
CREATE POLICY "user_update_own_notifications" ON notifications FOR UPDATE TO authenticated 
USING (user_id = auth.uid());

-- Public photos dapat dilihat semua authenticated user
CREATE POLICY "public_photos_read" ON photos FOR SELECT TO authenticated 
USING (is_public = true);

-- Users dapat upload photos untuk entitas yang mereka akses
CREATE POLICY "users_upload_photos" ON photos FOR INSERT TO authenticated 
WITH CHECK (uploaded_by = auth.uid());

-- =============================================
-- Indexes untuk Performance RLS
-- =============================================

-- Index untuk mempercepat RLS queries
CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_areas_manager_id ON areas(manager_id);
CREATE INDEX IF NOT EXISTS idx_trees_area_id ON trees(area_id);
CREATE INDEX IF NOT EXISTS idx_trees_planted_by ON trees(planted_by);
CREATE INDEX IF NOT EXISTS idx_tree_care_records_performed_by ON tree_care_records(performed_by);
CREATE INDEX IF NOT EXISTS idx_harvest_records_harvested_by ON harvest_records(harvested_by);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_photos_uploaded_by ON photos(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_photos_related_entity ON photos(related_entity_type, related_entity_id);

-- =============================================
-- Grant Permissions
-- =============================================

-- Grant usage pada schema auth untuk authenticated users
GRANT USAGE ON SCHEMA auth TO authenticated;

-- Grant execute pada helper functions
GRANT EXECUTE ON FUNCTION auth.user_role() TO authenticated;
GRANT EXECUTE ON FUNCTION auth.is_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION auth.user_managed_areas() TO authenticated;
GRANT EXECUTE ON FUNCTION auth.has_area_access(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION auth.has_permission(TEXT) TO authenticated;

-- =============================================
-- Comments untuk Dokumentasi
-- =============================================

COMMENT ON FUNCTION auth.user_role() IS 'Mengambil role name dari user yang sedang login';
COMMENT ON FUNCTION auth.is_admin() IS 'Mengecek apakah user saat ini adalah Admin';
COMMENT ON FUNCTION auth.user_managed_areas() IS 'Mengambil daftar area_id yang dikelola oleh Leader Area';
COMMENT ON FUNCTION auth.has_area_access(UUID) IS 'Mengecek apakah user memiliki akses ke area tertentu';
COMMENT ON FUNCTION auth.has_permission(TEXT) IS 'Mengecek permission spesifik dari role user';

-- =============================================
-- Row Level Security Implementation Complete
-- =============================================

/*
SUMMARY RLS POLICIES:

1. ADMIN ROLE:
   - Full access (SELECT, INSERT, UPDATE, DELETE) ke semua tabel
   - Exclusive access ke audit_logs

2. LEADER AREA ROLE:
   - Full access ke data dalam area yang mereka kelola
   - Read access ke master data (user_roles, tree_types, care_activities)
   - Access ke users, notifications, reports, photos dalam scope area mereka

3. SALES ROLE:
   - Read access ke trees, areas, tree_types
   - Full access ke harvest_records
   - Read access ke operational_costs dan harvest reports
   - Read access ke photos terkait trees dan harvest
   - Access ke notifications pribadi

4. PEKERJA ROLE:
   - Read access ke trees dalam area yang assigned
   - Read access ke care_activities
   - Full access ke tree_care_records dan harvest_records yang mereka buat
   - Read access ke records lain dalam area mereka
   - Access ke photos untuk pekerjaan mereka
   - Access ke notifications pribadi

5. SPECIAL POLICIES:
   - User dapat edit profile sendiri
   - User dapat read/update notifications mereka
   - Public photos dapat dilihat semua user
   - User dapat upload photos untuk entitas yang mereka akses

Helper functions mendukung logic RLS dengan mengecek role, area access, dan permissions.
Indexes ditambahkan untuk performance optimal pada RLS queries.
*/