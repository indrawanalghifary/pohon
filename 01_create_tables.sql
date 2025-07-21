-- =============================================
-- Aplikasi Manajemen Pohon - Database Tables
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- Table: user_roles
-- Description: Menyimpan jenis-jenis peran pengguna dalam sistem (admin, manager, worker, viewer)
-- =============================================
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(50) NOT NULL UNIQUE, -- nama role (admin, manager, worker, viewer)
  description TEXT, -- deskripsi lengkap role
  permissions JSONB DEFAULT '{}', -- izin-izin khusus dalam format JSON
  is_active BOOLEAN DEFAULT true, -- status aktif role
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: users
-- Description: Data pengguna yang extends dari Supabase Auth dengan informasi tambahan
-- =============================================
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  avatar_url TEXT,
  role_id UUID REFERENCES user_roles(id),
  employee_id VARCHAR(50) UNIQUE, -- ID karyawan untuk identifikasi
  department VARCHAR(100), -- departemen/divisi
  hire_date DATE, -- tanggal mulai bekerja
  is_active BOOLEAN DEFAULT true,
  last_login_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: areas
-- Description: Area atau lahan tempat pohon-pohon ditanam
-- =============================================
CREATE TABLE areas (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  code VARCHAR(20) UNIQUE NOT NULL, -- kode area untuk identifikasi cepat
  description TEXT,
  location TEXT, -- alamat atau deskripsi lokasi
  coordinates JSONB, -- koordinat GPS dalam format {"lat": x, "lng": y}
  total_area DECIMAL(10,2), -- luas area dalam m2
  soil_type VARCHAR(50), -- jenis tanah
  climate_zone VARCHAR(50), -- zona iklim
  manager_id UUID REFERENCES users(id), -- penanggung jawab area
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: tree_types
-- Description: Jenis-jenis pohon yang dapat ditanam
-- =============================================
CREATE TABLE tree_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  scientific_name VARCHAR(150), -- nama ilmiah
  local_name VARCHAR(100), -- nama lokal/daerah
  category VARCHAR(50), -- kategori (buah, kayu, hias, dll)
  description TEXT,
  planting_season VARCHAR(50), -- musim tanam optimal
  harvest_season VARCHAR(50), -- musim panen
  maturity_period_months INTEGER, -- periode hingga dewasa dalam bulan
  average_height_meters DECIMAL(5,2), -- tinggi rata-rata
  care_instructions TEXT, -- instruksi perawatan umum
  climate_requirements TEXT, -- persyaratan iklim
  soil_requirements TEXT, -- persyaratan tanah
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: trees
-- Description: Data individual setiap pohon yang ditanam
-- =============================================
CREATE TABLE trees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tree_code VARCHAR(50) UNIQUE NOT NULL, -- kode unik pohon
  tree_type_id UUID NOT NULL REFERENCES tree_types(id),
  area_id UUID NOT NULL REFERENCES areas(id),
  planted_by UUID REFERENCES users(id), -- yang menanam
  planting_date DATE NOT NULL,
  coordinates JSONB, -- koordinat spesifik pohon
  current_height_cm DECIMAL(6,2), -- tinggi saat ini dalam cm
  current_diameter_cm DECIMAL(6,2), -- diameter batang dalam cm
  health_status VARCHAR(20) DEFAULT 'healthy' CHECK (health_status IN ('healthy', 'sick', 'dead', 'critical')),
  growth_stage VARCHAR(20) DEFAULT 'seedling' CHECK (growth_stage IN ('seedling', 'young', 'mature', 'old')),
  notes TEXT, -- catatan khusus
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: care_activities
-- Description: Jenis-jenis aktivitas perawatan pohon
-- =============================================
CREATE TABLE care_activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) NOT NULL,
  description TEXT,
  category VARCHAR(50), -- kategori (penyiraman, pemupukan, pemangkasan, dll)
  frequency_days INTEGER, -- frekuensi dalam hari (optional)
  estimated_duration_minutes INTEGER, -- estimasi durasi dalam menit
  required_tools TEXT, -- alat yang dibutuhkan
  instructions TEXT, -- instruksi detail
  safety_notes TEXT, -- catatan keselamatan
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: tree_care_records
-- Description: Catatan perawatan yang dilakukan pada setiap pohon
-- =============================================
CREATE TABLE tree_care_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tree_id UUID NOT NULL REFERENCES trees(id),
  care_activity_id UUID NOT NULL REFERENCES care_activities(id),
  performed_by UUID NOT NULL REFERENCES users(id),
  performed_at TIMESTAMPTZ NOT NULL,
  duration_minutes INTEGER, -- durasi aktual perawatan
  notes TEXT, -- catatan hasil perawatan
  before_condition TEXT, -- kondisi sebelum perawatan
  after_condition TEXT, -- kondisi setelah perawatan
  materials_used JSONB, -- bahan yang digunakan dalam format JSON
  cost_amount DECIMAL(12,2), -- biaya perawatan
  weather_condition VARCHAR(50), -- kondisi cuaca saat perawatan
  is_scheduled BOOLEAN DEFAULT false, -- apakah perawatan terjadwal
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: harvest_records
-- Description: Catatan hasil panen dari pohon-pohon produktif
-- =============================================
CREATE TABLE harvest_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tree_id UUID NOT NULL REFERENCES trees(id),
  harvested_by UUID NOT NULL REFERENCES users(id),
  harvest_date DATE NOT NULL,
  quantity DECIMAL(10,2) NOT NULL, -- jumlah panen
  unit VARCHAR(20) NOT NULL, -- satuan (kg, pcs, ton, dll)
  quality_grade VARCHAR(20), -- grade kualitas (A, B, C, premium, dll)
  market_price_per_unit DECIMAL(12,2), -- harga pasar per unit
  total_value DECIMAL(15,2), -- total nilai panen
  storage_location TEXT, -- lokasi penyimpanan
  buyer_info TEXT, -- informasi pembeli
  notes TEXT, -- catatan tambahan
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: operational_costs
-- Description: Catatan biaya operasional untuk manajemen pohon
-- =============================================
CREATE TABLE operational_costs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category VARCHAR(50) NOT NULL, -- kategori biaya (tools, materials, labor, maintenance, dll)
  subcategory VARCHAR(100), -- subkategori lebih spesifik
  description TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'IDR',
  date DATE NOT NULL,
  area_id UUID REFERENCES areas(id), -- area terkait (optional)
  tree_id UUID REFERENCES trees(id), -- pohon terkait (optional)
  vendor_name VARCHAR(100), -- nama supplier/vendor
  invoice_number VARCHAR(100), -- nomor invoice
  payment_method VARCHAR(50), -- metode pembayaran
  paid_by UUID REFERENCES users(id), -- yang melakukan pembayaran
  approved_by UUID REFERENCES users(id), -- yang menyetujui
  receipt_url TEXT, -- URL file bukti pembayaran
  is_recurring BOOLEAN DEFAULT false, -- apakah biaya berulang
  recurrence_pattern VARCHAR(50), -- pola pengulangan (monthly, yearly, dll)
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'paid', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: notifications
-- Description: Sistem notifikasi untuk mengingatkan aktivitas dan perawatan
-- =============================================
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id),
  title VARCHAR(200) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) NOT NULL, -- care_reminder, harvest_time, maintenance_due, alert, etc
  priority VARCHAR(10) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  related_entity_type VARCHAR(50), -- tree, area, care_record, dll
  related_entity_id UUID, -- ID entitas terkait
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  action_required BOOLEAN DEFAULT false, -- apakah perlu tindakan
  action_url TEXT, -- URL untuk tindakan
  scheduled_for TIMESTAMPTZ, -- waktu notifikasi dijadwalkan
  sent_at TIMESTAMPTZ, -- waktu notifikasi dikirim
  expires_at TIMESTAMPTZ, -- waktu kadaluarsa notifikasi
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: reports
-- Description: Laporan yang dihasilkan sistem untuk berbagai keperluan
-- =============================================
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title VARCHAR(200) NOT NULL,
  type VARCHAR(50) NOT NULL, -- daily, weekly, monthly, annual, custom
  category VARCHAR(50), -- care_summary, harvest_report, cost_analysis, dll
  description TEXT,
  generated_by UUID NOT NULL REFERENCES users(id),
  area_id UUID REFERENCES areas(id), -- area scope (optional untuk laporan spesifik)
  date_from DATE NOT NULL,
  date_to DATE NOT NULL,
  parameters JSONB, -- parameter laporan dalam format JSON
  data JSONB, -- data laporan dalam format JSON
  summary_stats JSONB, -- statistik ringkasan
  file_url TEXT, -- URL file laporan (PDF, Excel, dll)
  file_format VARCHAR(10), -- format file (pdf, xlsx, csv, dll)
  status VARCHAR(20) DEFAULT 'generating' CHECK (status IN ('generating', 'completed', 'failed')),
  is_scheduled BOOLEAN DEFAULT false, -- apakah laporan terjadwal
  schedule_pattern VARCHAR(50), -- pola jadwal laporan
  next_generation_date DATE, -- tanggal generate berikutnya
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: photos
-- Description: Foto-foto dokumentasi pohon, perawatan, dan kondisi
-- =============================================
CREATE TABLE photos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  filename VARCHAR(255) NOT NULL,
  original_filename VARCHAR(255),
  file_path TEXT NOT NULL, -- path file di storage
  file_url TEXT NOT NULL, -- URL akses file
  file_size_bytes BIGINT,
  mime_type VARCHAR(100),
  width_px INTEGER,
  height_px INTEGER,
  uploaded_by UUID NOT NULL REFERENCES users(id),
  related_entity_type VARCHAR(50) NOT NULL, -- tree, area, care_record, harvest_record, dll
  related_entity_id UUID NOT NULL, -- ID entitas terkait
  photo_type VARCHAR(50), -- before, after, progress, condition, documentation
  caption TEXT, -- deskripsi foto
  taken_at TIMESTAMPTZ, -- waktu foto diambil
  coordinates JSONB, -- koordinat GPS saat foto diambil
  weather_condition VARCHAR(50), -- kondisi cuaca saat foto
  tags TEXT[], -- tag untuk pencarian
  is_primary BOOLEAN DEFAULT false, -- apakah foto utama
  is_public BOOLEAN DEFAULT false, -- apakah bisa diakses publik
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Table: audit_logs
-- Description: Log audit untuk melacak semua perubahan data penting
-- =============================================
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id), -- user yang melakukan aksi
  action VARCHAR(50) NOT NULL, -- CREATE, UPDATE, DELETE, LOGIN, LOGOUT, dll
  entity_type VARCHAR(50) NOT NULL, -- tabel yang diubah
  entity_id UUID, -- ID record yang diubah
  old_values JSONB, -- nilai sebelum perubahan
  new_values JSONB, -- nilai setelah perubahan
  changed_fields TEXT[], -- field yang berubah
  ip_address INET, -- IP address user
  user_agent TEXT, -- browser/app yang digunakan
  session_id VARCHAR(255), -- ID sesi
  request_id VARCHAR(255), -- ID request untuk tracing
  additional_info JSONB, -- informasi tambahan
  severity VARCHAR(10) DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'error', 'critical')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- Add Comments for Better Documentation
-- =============================================

COMMENT ON TABLE user_roles IS 'Menyimpan jenis-jenis peran pengguna dalam sistem manajemen pohon';
COMMENT ON TABLE users IS 'Data pengguna yang extends dari Supabase Auth dengan informasi karyawan';
COMMENT ON TABLE areas IS 'Area atau lahan tempat pohon-pohon ditanam dan dikelola';
COMMENT ON TABLE tree_types IS 'Master data jenis-jenis pohon yang dapat ditanam';
COMMENT ON TABLE trees IS 'Data individual setiap pohon yang ditanam di area';
COMMENT ON TABLE care_activities IS 'Master data jenis-jenis aktivitas perawatan pohon';
COMMENT ON TABLE tree_care_records IS 'Catatan historis perawatan yang dilakukan pada setiap pohon';
COMMENT ON TABLE harvest_records IS 'Catatan hasil panen dari pohon-pohon produktif';
COMMENT ON TABLE operational_costs IS 'Catatan biaya operasional untuk manajemen pohon dan area';
COMMENT ON TABLE notifications IS 'Sistem notifikasi untuk mengingatkan aktivitas dan jadwal';
COMMENT ON TABLE reports IS 'Laporan yang dihasilkan sistem untuk analisis dan monitoring';
COMMENT ON TABLE photos IS 'Dokumentasi foto pohon, kondisi, dan aktivitas perawatan';
COMMENT ON TABLE audit_logs IS 'Log audit untuk melacak semua perubahan data dan aktivitas user';

-- =============================================
-- Database Schema Creation Complete
-- =============================================