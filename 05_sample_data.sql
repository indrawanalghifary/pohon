-- =============================================
-- Aplikasi Manajemen Pohon - Sample Data
-- =============================================

-- =============================================
-- Insert Default User Roles
-- =============================================

INSERT INTO user_roles (id, name, description, permissions, is_active) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Admin', 'Administrator sistem dengan akses penuh', '{"all": true, "manage_users": true, "manage_areas": true, "view_reports": true, "manage_system": true}', true),
('550e8400-e29b-41d4-a716-446655440002', 'Sales', 'Tim penjualan hasil panen', '{"view_trees": true, "manage_harvest": true, "view_reports": true, "export_data": true}', true),
('550e8400-e29b-41d4-a716-446655440003', 'Leader Area', 'Kepala area yang mengelola wilayah tertentu', '{"manage_area": true, "manage_trees": true, "manage_workers": true, "view_reports": true, "approve_costs": true}', true),
('550e8400-e29b-41d4-a716-446655440004', 'Pekerja', 'Pekerja lapangan yang melakukan perawatan pohon', '{"record_care": true, "record_harvest": true, "upload_photos": true, "view_assigned_trees": true}', true);

-- =============================================
-- Insert Sample Areas (Lokasi di Indonesia)
-- Note: manager_id akan diupdate setelah users diinsert untuk menghindari circular dependency
-- =============================================

INSERT INTO areas (id, name, code, description, location, coordinates, total_area, soil_type, climate_zone, is_active) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'Kebun Durian Medan', 'KDM001', 'Area perkebunan durian di Medan, Sumatera Utara', 'Jl. Perkebunan Raya No. 123, Medan Johor, Medan, Sumatera Utara', '{"lat": 3.595196, "lng": 98.672226}', 50000.00, 'Tanah Alluvial', 'Tropis Basah', true),
('660e8400-e29b-41d4-a716-446655440002', 'Kebun Mangga Cirebon', 'KMC002', 'Area perkebunan mangga di Cirebon, Jawa Barat', 'Desa Babakan, Kec. Ciledug, Cirebon, Jawa Barat', '{"lat": -6.732296, "lng": 108.552147}', 35000.00, 'Tanah Latosol', 'Tropis Kering', true),
('660e8400-e29b-41d4-a716-446655440003', 'Kebun Rambutan Yogya', 'KRY003', 'Area perkebunan rambutan di Yogyakarta', 'Desa Sleman, Kec. Mlati, Sleman, DIY Yogyakarta', '{"lat": -7.747160, "lng": 110.342430}', 25000.00, 'Tanah Regosol', 'Tropis Sedang', true);

-- =============================================
-- Insert Sample Tree Types (Pohon Buah Indonesia)
-- =============================================

INSERT INTO tree_types (id, name, scientific_name, local_name, category, description, planting_season, harvest_season, maturity_period_months, average_height_meters, care_instructions, climate_requirements, soil_requirements, is_active) VALUES
('770e8400-e29b-41d4-a716-446655440001', 'Durian Musang King', 'Durio zibethinus', 'Durian Raja', 'Buah', 'Durian premium dengan rasa manis dan daging tebal', 'Musim Hujan (Nov-Feb)', 'Musim Kemarau (Jun-Sep)', 60, 25.00, 'Penyiraman rutin, pemupukan 3 bulan sekali, pemangkasan annual', 'Iklim tropis basah, curah hujan 1500-2500mm/tahun', 'Tanah lempung berpasir, pH 6.0-7.0, drainase baik', true),
('770e8400-e29b-41d4-a716-446655440002', 'Mangga Gedong Gincu', 'Mangifera indica', 'Mangga Manis', 'Buah', 'Mangga unggulan Cirebon dengan rasa manis dan aroma harum', 'Awal Musim Hujan (Okt-Nov)', 'Musim Kemarau (Jul-Okt)', 36, 15.00, 'Penyiraman saat kemarau, pemupukan 4 bulan sekali, pemangkasan bentuk', 'Iklim tropis kering, suhu 24-27°C', 'Tanah liat berpasir, pH 5.5-7.5, tidak tergenang', true),
('770e8400-e29b-41d4-a716-446655440003', 'Rambutan Binjai', 'Nephelium lappaceum', 'Rambutan Manis', 'Buah', 'Rambutan dengan daging tebal dan manis', 'Musim Hujan (Des-Feb)', 'Musim Kemarau (Jun-Agt)', 48, 12.00, 'Penyiraman teratur, pemupukan NPK 6 bulan sekali', 'Iklim tropis lembab, kelembaban tinggi', 'Tanah subur berhumus, pH 6.0-6.5', true),
('770e8400-e29b-41d4-a716-446655440004', 'Kelengkeng Diamond River', 'Dimocarpus longan', 'Lengkeng Madu', 'Buah', 'Kelengkeng berkualitas premium dengan rasa sangat manis', 'Musim Kemarau (Apr-Jun)', 'Musim Hujan (Nov-Jan)', 42, 10.00, 'Pengairan drip system, pemupukan organik rutin', 'Iklim sub-tropis, suhu 20-30°C', 'Tanah gembur, pH 6.0-7.0, drainase sempurna', true),
('770e8400-e29b-41d4-a716-446655440005', 'Jeruk Bali Magetan', 'Citrus maxima', 'Jeruk Bali Lokal', 'Buah', 'Jeruk bali khas Jawa Timur dengan rasa segar', 'Musim Hujan (Nov-Jan)', 'Sepanjang Tahun', 24, 8.00, 'Penyiraman harian, pemupukan bulanan, kontrol hama rutin', 'Iklim tropis, suhu stabil 25-30°C', 'Tanah subur, pH 6.0-7.5, tidak becek', true),
('770e8400-e29b-41d4-a716-446655440006', 'Jambu Air Semarang', 'Syzygium aqueum', 'Jambu Air Merah', 'Buah', 'Jambu air dengan tekstur renyah dan rasa segar', 'Sepanjang Tahun', 'Sepanjang Tahun', 18, 6.00, 'Penyiraman teratur, pemangkasan rutin, pemupukan 3 bulan sekali', 'Iklim tropis lembab', 'Tanah lempung, pH 5.5-6.5, air tersedia', true),
('770e8400-e29b-41d4-a716-446655440007', 'Alpukat Mentega', 'Persea americana', 'Alpukat Lokal', 'Buah', 'Alpukat dengan tekstur lembut seperti mentega', 'Musim Hujan (Okt-Des)', 'Musim Kemarau (May-Jul)', 30, 12.00, 'Penyiraman sedang, pemupukan organik, mulching', 'Iklim sejuk tropis, suhu 15-25°C', 'Tanah vulkanik, pH 6.0-7.0, drainase baik', true);

-- =============================================
-- Insert Sample Care Activities (Kegiatan Perawatan)
-- =============================================

INSERT INTO care_activities (id, name, description, category, frequency_days, estimated_duration_minutes, required_tools, instructions, safety_notes, is_active) VALUES
('880e8400-e29b-41d4-a716-446655440001', 'Penyiraman Rutin', 'Penyiraman pohon sesuai kebutuhan air', 'Penyiraman', 7, 30, 'Selang air, sprinkler, ember', 'Siram hingga tanah lembab merata, hindari genangan air di sekitar batang', 'Gunakan sepatu anti slip, hindari penyiraman saat hujan', true),
('880e8400-e29b-41d4-a716-446655440002', 'Pemupukan NPK', 'Pemberian pupuk NPK untuk pertumbuhan optimal', 'Pemupukan', 90, 45, 'Pupuk NPK, cangkul, sarung tangan', 'Buat lubang di sekitar pangkal pohon, masukkan pupuk dan tutup dengan tanah', 'Gunakan masker dan sarung tangan, cuci tangan setelah selesai', true),
('880e8400-e29b-41d4-a716-446655440003', 'Pemangkasan Cabang', 'Pemangkasan cabang mati atau tidak produktif', 'Pemangkasan', 180, 60, 'Gunting pangkas, gergaji, tangga', 'Potong cabang yang mati, sakit, atau mengganggu bentuk pohon', 'Gunakan tangga yang stabil, hati-hati dengan alat tajam', true),
('880e8400-e29b-41d4-a716-446655440004', 'Penyiangan Gulma', 'Pembersihan gulma di sekitar pohon', 'Penyiangan', 14, 20, 'Cangkul kecil, sabit, plastik sampah', 'Bersihkan gulma dalam radius 2 meter dari batang pohon', 'Gunakan sarung tangan, hindari merusak akar pohon', true),
('880e8400-e29b-41d4-a716-446655440005', 'Pengendalian Hama', 'Penyemprotan pestisida untuk mengendalikan hama', 'Pengendalian Hama', 30, 90, 'Sprayer, pestisida, masker, sarung tangan', 'Semprot pestisida sesuai dosis, fokus pada daun dan cabang', 'Wajib gunakan APD lengkap, hindari angin kencang', true),
('880e8400-e29b-41d4-a716-446655440006', 'Monitoring Kesehatan', 'Pemeriksaan kondisi kesehatan pohon secara menyeluruh', 'Monitoring', 14, 15, 'Form checklist, kamera, alat ukur', 'Periksa daun, batang, buah, dan tanda-tanda penyakit', 'Catat temuan dengan detail, foto kondisi abnormal', true),
('880e8400-e29b-41d4-a716-446655440007', 'Pemberian Mulsa', 'Pemberian mulsa organik di sekitar pohon', 'Lainnya', 120, 30, 'Mulsa organik, sekop, garu', 'Sebar mulsa dalam radius 1.5 meter dari batang, tebal 5-8 cm', 'Pastikan mulsa tidak menempel langsung ke batang pohon', true);

-- =============================================
-- Insert Sample Users (Dummy Users untuk Testing)
-- =============================================

-- Note: Dalam implementasi nyata, users akan dibuat melalui Supabase Auth
-- Data berikut untuk referensi dan testing saja

INSERT INTO users (id, email, name, phone, role_id, employee_id, department, hire_date, is_active) VALUES
-- Admin Users
('990e8400-e29b-41d4-a716-446655440001', 'admin@pohon.app', 'Budi Santoso', '081234567890', '550e8400-e29b-41d4-a716-446655440001', 'EMP001', 'IT & Systems', '2023-01-15', true),
('990e8400-e29b-41d4-a716-446655440002', 'admin2@pohon.app', 'Sari Indah', '081234567891', '550e8400-e29b-41d4-a716-446655440001', 'EMP002', 'Management', '2023-02-01', true),

-- Sales Users  
('990e8400-e29b-41d4-a716-446655440003', 'sales@pohon.app', 'Agus Wijaya', '081234567892', '550e8400-e29b-41d4-a716-446655440002', 'EMP003', 'Sales & Marketing', '2023-03-15', true),
('990e8400-e29b-41d4-a716-446655440004', 'sales2@pohon.app', 'Rina Kusuma', '081234567893', '550e8400-e29b-41d4-a716-446655440002', 'EMP004', 'Sales & Marketing', '2023-04-01', true),

-- Leader Area Users
('990e8400-e29b-41d4-a716-446655440005', 'leader.medan@pohon.app', 'Dedi Kurniawan', '081234567894', '550e8400-e29b-41d4-a716-446655440003', 'EMP005', 'Operations', '2023-02-15', true),
('990e8400-e29b-41d4-a716-446655440006', 'leader.cirebon@pohon.app', 'Wati Suharto', '081234567895', '550e8400-e29b-41d4-a716-446655440003', 'EMP006', 'Operations', '2023-03-01', true),
('990e8400-e29b-41d4-a716-446655440007', 'leader.yogya@pohon.app', 'Bambang Prasetyo', '081234567896', '550e8400-e29b-41d4-a716-446655440003', 'EMP007', 'Operations', '2023-03-15', true),

-- Pekerja Users
('990e8400-e29b-41d4-a716-446655440008', 'pekerja1@pohon.app', 'Joko Susilo', '081234567897', '550e8400-e29b-41d4-a716-446655440004', 'EMP008', 'Field Work', '2023-04-01', true),
('990e8400-e29b-41d4-a716-446655440009', 'pekerja2@pohon.app', 'Ahmad Fadli', '081234567898', '550e8400-e29b-41d4-a716-446655440004', 'EMP009', 'Field Work', '2023-04-15', true),
('990e8400-e29b-41d4-a716-446655440010', 'pekerja3@pohon.app', 'Surti Rahayu', '081234567899', '550e8400-e29b-41d4-a716-446655440004', 'EMP010', 'Field Work', '2023-05-01', true),
('990e8400-e29b-41d4-a716-446655440011', 'pekerja4@pohon.app', 'Eko Prawirodjo', '081234567900', '550e8400-e29b-41d4-a716-446655440004', 'EMP011', 'Field Work', '2023-05-15', true),
('990e8400-e29b-41d4-a716-446655440012', 'pekerja5@pohon.app', 'Maya Sari', '081234567901', '550e8400-e29b-41d4-a716-446655440004', 'EMP012', 'Field Work', '2023-06-01', true);

-- Update areas dengan manager_id
UPDATE areas SET manager_id = '990e8400-e29b-41d4-a716-446655440005' WHERE id = '660e8400-e29b-41d4-a716-446655440001'; -- Medan
UPDATE areas SET manager_id = '990e8400-e29b-41d4-a716-446655440006' WHERE id = '660e8400-e29b-41d4-a716-446655440002'; -- Cirebon  
UPDATE areas SET manager_id = '990e8400-e29b-41d4-a716-446655440007' WHERE id = '660e8400-e29b-41d4-a716-446655440003'; -- Yogya

-- =============================================
-- Insert Sample Trees
-- =============================================

INSERT INTO trees (id, tree_code, tree_type_id, area_id, planted_by, planting_date, coordinates, current_height_cm, current_diameter_cm, health_status, growth_stage, notes) VALUES
-- Trees di Kebun Durian Medan
('aa0e8400-e29b-41d4-a716-446655440001', 'TRE-20230215-0001', '770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440008', '2023-02-15', '{"lat": 3.595200, "lng": 98.672230}', 320.50, 45.20, 'healthy', 'young', 'Durian musang king, pertumbuhan baik'),
('aa0e8400-e29b-41d4-a716-446655440002', 'TRE-20230216-0002', '770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440008', '2023-02-16', '{"lat": 3.595210, "lng": 98.672240}', 315.00, 43.80, 'healthy', 'young', 'Durian musang king, bibit unggul'),
('aa0e8400-e29b-41d4-a716-446655440003', 'TRE-20230220-0003', '770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440009', '2023-02-20', '{"lat": 3.595220, "lng": 98.672250}', 298.75, 41.50, 'healthy', 'young', 'Durian musang king, area terlindung'),

-- Trees di Kebun Mangga Cirebon
('aa0e8400-e29b-41d4-a716-446655440004', 'TRE-20220315-0004', '770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440010', '2022-03-15', '{"lat": -6.732300, "lng": 108.552150}', 480.20, 65.30, 'healthy', 'mature', 'Mangga gedong gincu, sudah berbuah'),
('aa0e8400-e29b-41d4-a716-446655440005', 'TRE-20220318-0005', '770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440010', '2022-03-18', '{"lat": -6.732310, "lng": 108.552160}', 475.80, 63.70, 'healthy', 'mature', 'Mangga gedong gincu, produktif tinggi'),
('aa0e8400-e29b-41d4-a716-446655440006', 'TRE-20220320-0006', '770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440011', '2022-03-20', '{"lat": -6.732320, "lng": 108.552170}', 465.50, 61.90, 'healthy', 'mature', 'Mangga gedong gincu, kualitas prima'),

-- Trees di Kebun Rambutan Yogya  
('aa0e8400-e29b-41d4-a716-446655440007', 'TRE-20220815-0007', '770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440012', '2022-08-15', '{"lat": -7.747170, "lng": 110.342440}', 380.60, 52.40, 'healthy', 'mature', 'Rambutan binjai, sudah mulai berbuah'),
('aa0e8400-e29b-41d4-a716-446655440008', 'TRE-20220818-0008', '770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440012', '2022-08-18', '{"lat": -7.747180, "lng": 110.342450}', 375.20, 50.80, 'healthy', 'mature', 'Rambutan binjai, pertumbuhan optimal'),

-- Trees Kelengkeng (Mixed areas untuk variasi)
('aa0e8400-e29b-41d4-a716-446655440009', 'TRE-20230401-0009', '770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440008', '2023-04-01', '{"lat": 3.595250, "lng": 98.672280}', 180.30, 28.50, 'healthy', 'young', 'Kelengkeng diamond river, bibit import'),
('aa0e8400-e29b-41d4-a716-446655440010', 'TRE-20230405-0010', '770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440010', '2023-04-05', '{"lat": -6.732350, "lng": 108.552200}', 175.80, 27.20, 'healthy', 'young', 'Kelengkeng diamond river, adaptasi baik');

-- =============================================
-- Insert Sample Tree Care Records
-- =============================================

INSERT INTO tree_care_records (id, tree_id, care_activity_id, performed_by, performed_at, duration_minutes, notes, before_condition, after_condition, materials_used, cost_amount, weather_condition, is_scheduled) VALUES
-- Care records untuk Durian di Medan
('bb0e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440008', '2024-01-15 08:00:00', 25, 'Penyiraman rutin pagi hari', 'Tanah agak kering', 'Tanah lembab merata', '{"air": "50 liter"}', 15000, 'Cerah', true),
('bb0e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440001', '880e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440008', '2024-01-20 09:30:00', 40, 'Pemupukan NPK sesuai jadwal', 'Pertumbuhan normal', 'Daun lebih hijau setelah pemupukan', '{"pupuk_npk": "2 kg"}', 75000, 'Berawan', true),
('bb0e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440002', '880e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440009', '2024-01-18 07:45:00', 18, 'Pembersihan gulma di sekitar pohon', 'Ada gulma mengganggu', 'Area bersih dari gulma', '{"plastik_sampah": "2 buah"}', 25000, 'Cerah', true),

-- Care records untuk Mangga di Cirebon
('bb0e8400-e29b-41d4-a716-446655440004', 'aa0e8400-e29b-41d4-a716-446655440004', '880e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440010', '2024-01-10 10:00:00', 12, 'Monitoring kesehatan rutin', 'Kondisi baik secara umum', 'Pohon sehat, buah berkembang baik', '{}', 10000, 'Cerah', true),
('bb0e8400-e29b-41d4-a716-446655440005', 'aa0e8400-e29b-41d4-a716-446655440005', '880e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440010', '2024-01-25 14:00:00', 55, 'Pemangkasan cabang kering dan tidak produktif', 'Ada beberapa cabang mati', 'Bentuk pohon lebih rapi, sirkulasi udara baik', '{"oli_gergaji": "500ml"}', 45000, 'Cerah', true),

-- Care records untuk Rambutan di Yogya
('bb0e8400-e29b-41d4-a716-446655440006', 'aa0e8400-e29b-41d4-a716-446655440007', '880e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440012', '2024-01-12 16:00:00', 85, 'Penyemprotan pestisida untuk ulat buah', 'Ditemukan hama ulat pada buah', 'Hama terkendali, buah lebih sehat', '{"pestisida": "200ml", "air": "20 liter"}', 125000, 'Berawan', true),
('bb0e8400-e29b-41d4-a716-446655440007', 'aa0e8400-e29b-41d4-a716-446655440008', '880e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440012', '2024-01-22 08:30:00', 28, 'Pemberian mulsa organik', 'Tanah keras, kurang nutrisi', 'Tanah lebih gembur, nutrisi terjaga', '{"mulsa_jerami": "50 kg"}', 35000, 'Cerah', true);

-- =============================================
-- Insert Sample Harvest Records
-- =============================================

INSERT INTO harvest_records (id, tree_id, harvested_by, harvest_date, quantity, unit, quality_grade, market_price_per_unit, total_value, storage_location, buyer_info, notes) VALUES
-- Harvest Mangga Cirebon (sudah mature)
('cc0e8400-e29b-41d4-a716-446655440001', 'aa0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440010', '2024-01-28', 85.50, 'kg', 'Premium', 25000, 2137500, 'Gudang Cirebon', 'PT Buah Segar Jakarta - Pak Ahmad (081234555666)', 'Mangga gedong gincu grade premium, kualitas ekspor'),
('cc0e8400-e29b-41d4-a716-446655440002', 'aa0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440010', '2024-01-30', 92.30, 'kg', 'Premium', 25000, 2307500, 'Gudang Cirebon', 'Pasar Induk Kramat Jati - Bu Siti (081234555777)', 'Mangga gedong gincu, rasa manis sempurna'),

-- Harvest Rambutan Yogya (sudah mature)  
('cc0e8400-e29b-41d4-a716-446655440003', 'aa0e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440012', '2024-01-26', 65.20, 'kg', 'A', 18000, 1173600, 'Gudang Sleman', 'Pasar Beringharjo - Pak Joko (081234555888)', 'Rambutan binjai grade A, daging tebal'),
('cc0e8400-e29b-41d4-a716-446655440004', 'aa0e8400-e29b-41d4-a716-446655440008', '990e8400-e29b-41d4-a716-446655440012', '2024-01-29', 58.75, 'kg', 'A', 18000, 1057500, 'Gudang Sleman', 'Supermarket Yogya - Bu Ratna (081234555999)', 'Rambutan binjai segar, kemasan retail');

-- =============================================
-- Insert Sample Operational Costs
-- =============================================

INSERT INTO operational_costs (id, category, subcategory, description, amount, currency, date, area_id, vendor_name, invoice_number, payment_method, paid_by, approved_by, status) VALUES
-- Operational costs Medan
('dd0e8400-e29b-41d4-a716-446655440001', 'Tools', 'Gardening Equipment', 'Pembelian sprayer dan selang air baru', 850000, 'IDR', '2024-01-05', '660e8400-e29b-41d4-a716-446655440001', 'Toko Pertanian Medan Jaya', 'INV-2024-001', 'Transfer Bank', '990e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440001', 'paid'),
('dd0e8400-e29b-41d4-a716-446655440002', 'Materials', 'Fertilizer', 'Pembelian pupuk NPK 50 kg untuk area Medan', 1250000, 'IDR', '2024-01-10', '660e8400-e29b-41d4-a716-446655440001', 'CV Pupuk Subur Makmur', 'INV-2024-005', 'Cash', '990e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440001', 'paid'),

-- Operational costs Cirebon
('dd0e8400-e29b-41d4-a716-446655440003', 'Labor', 'Seasonal Worker', 'Upah pekerja musiman untuk panen mangga', 2400000, 'IDR', '2024-01-28', '660e8400-e29b-41d4-a716-446655440002', 'Pekerja Lepas Cirebon', 'PAYROLL-JAN-24', 'Cash', '990e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440001', 'paid'),
('dd0e8400-e29b-41d4-a716-446655440004', 'Maintenance', 'Equipment Repair', 'Service mesin pompa air dan ganti spare part', 675000, 'IDR', '2024-01-15', '660e8400-e29b-41d4-a716-446655440002', 'Bengkel Teknik Jaya', 'INV-2024-012', 'Transfer Bank', '990e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440001', 'paid'),

-- Operational costs Yogya
('dd0e8400-e29b-41d4-a716-446655440005', 'Materials', 'Pesticide', 'Pembelian pestisida organik dan perekat', 450000, 'IDR', '2024-01-12', '660e8400-e29b-41d4-a716-446655440003', 'Toko Kimia Pertanian', 'INV-2024-008', 'Transfer Bank', '990e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440001', 'paid'),
('dd0e8400-e29b-41d4-a716-446655440006', 'Materials', 'Mulching', 'Pembelian jerami untuk mulsa organik', 320000, 'IDR', '2024-01-20', '660e8400-e29b-41d4-a716-446655440003', 'Petani Jerami Sleman', 'NOTA-JAN-001', 'Cash', '990e8400-e29b-41d4-a716-446655440007', '990e8400-e29b-41d4-a716-446655440001', 'paid');

-- =============================================
-- Insert Sample Notifications
-- =============================================

INSERT INTO notifications (id, user_id, title, message, type, priority, related_entity_type, related_entity_id, is_read, scheduled_for, expires_at) VALUES
-- Notifications untuk Admin
('ee0e8400-e29b-41d4-a716-446655440001', '990e8400-e29b-41d4-a716-446655440001', 'Laporan Panen Bulan Januari', 'Total panen bulan ini mencapai 301.75 kg dengan nilai Rp 6.675.100. Detail laporan tersedia di dashboard.', 'system', 'normal', 'report', NULL, false, NOW(), NOW() + INTERVAL '7 days'),

-- Notifications untuk Leader Area
('ee0e8400-e29b-41d4-a716-446655440002', '990e8400-e29b-41d4-a716-446655440005', 'Perawatan Durian Jatuh Tempo', 'Pohon TRE-20230215-0001 memerlukan pemupukan dalam 3 hari ke depan. Harap dijadwalkan segera.', 'care_reminder', 'high', 'tree', 'aa0e8400-e29b-41d4-a716-446655440001', false, NOW(), NOW() + INTERVAL '5 days'),
('ee0e8400-e29b-41d4-a716-446655440003', '990e8400-e29b-41d4-a716-446655440006', 'Panen Mangga Berhasil', 'Panen mangga gedong gincu sebesar 85.50 kg telah berhasil dilakukan dengan total nilai Rp 2.137.500', 'harvest_time', 'normal', 'harvest_record', 'cc0e8400-e29b-41d4-a716-446655440001', false, NOW(), NOW() + INTERVAL '7 days'),

-- Notifications untuk Sales
('ee0e8400-e29b-41d4-a716-446655440004', '990e8400-e29b-41d4-a716-446655440003', 'Stok Mangga Tersedia', 'Mangga gedong gincu grade premium tersedia 177.8 kg siap untuk distribusi ke buyer.', 'system', 'normal', 'harvest_record', 'cc0e8400-e29b-41d4-a716-446655440002', false, NOW(), NOW() + INTERVAL '7 days'),

-- Notifications untuk Pekerja
('ee0e8400-e29b-41d4-a716-446655440005', '990e8400-e29b-41d4-a716-446655440008', 'Tugas Penyiraman Hari Ini', 'Jadwal penyiraman rutin untuk 3 pohon durian di area Medan. Estimasi waktu: 90 menit.', 'care_reminder', 'normal', 'care_record', 'bb0e8400-e29b-41d4-a716-446655440001', false, NOW(), NOW() + INTERVAL '3 days'),
('ee0e8400-e29b-41d4-a716-446655440006', '990e8400-e29b-41d4-a716-446655440012', 'Monitoring Rambutan', 'Lakukan monitoring kesehatan untuk pohon rambutan TRE-20220815-0007 dan TRE-20220818-0008.', 'care_reminder', 'normal', 'tree', 'aa0e8400-e29b-41d4-a716-446655440007', false, NOW(), NOW() + INTERVAL '5 days');

-- =============================================
-- Insert Sample Reports
-- =============================================

INSERT INTO reports (id, title, type, category, description, generated_by, area_id, date_from, date_to, data, summary_stats, status, is_scheduled) VALUES
('ff0e8400-e29b-41d4-a716-446655440001', 'Laporan Mingguan Medan - 22-28 Jan 2024', 'weekly', 'care_summary', 'Laporan aktivitas perawatan mingguan area Medan', '990e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '2024-01-22', '2024-01-28', 
'{"total_activities": 5, "total_cost": 160000, "activities": [{"name": "Penyiraman", "count": 2}, {"name": "Pemupukan", "count": 1}, {"name": "Penyiangan", "count": 2}]}', 
'{"trees_maintained": 3, "avg_cost_per_activity": 32000, "completion_rate": "100%"}', 'completed', true),

('ff0e8400-e29b-41d4-a716-446655440002', 'Laporan Panen Cirebon - Januari 2024', 'monthly', 'harvest_report', 'Laporan hasil panen bulanan area Cirebon', '990e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', '2024-01-01', '2024-01-31',
'{"total_quantity": 177.8, "total_value": 4445000, "harvest_count": 2, "average_quality": "Premium", "main_product": "Mangga Gedong Gincu"}',
'{"productivity": "High", "revenue_growth": "+15%", "quality_consistency": "Excellent"}', 'completed', true);

-- =============================================
-- Data Sample Selesai - Summary
-- =============================================

/*
SUMMARY DATA SAMPLE YANG TELAH DIINSERT:

1. USER ROLES (4 roles):
   - Admin: Akses penuh sistem
   - Sales: Mengelola penjualan hasil panen  
   - Leader Area: Mengelola area tertentu
   - Pekerja: Melakukan perawatan lapangan

2. AREAS (3 areas di Indonesia):
   - Kebun Durian Medan (50 ha)
   - Kebun Mangga Cirebon (35 ha) 
   - Kebun Rambutan Yogya (25 ha)

3. TREE TYPES (7 jenis pohon lokal):
   - Durian Musang King
   - Mangga Gedong Gincu
   - Rambutan Binjai
   - Kelengkeng Diamond River
   - Jeruk Bali Magetan
   - Jambu Air Semarang
   - Alpukat Mentega

4. CARE ACTIVITIES (7 aktivitas):
   - Penyiraman Rutin (7 hari)
   - Pemupukan NPK (90 hari)
   - Pemangkasan Cabang (180 hari)
   - Penyiangan Gulma (14 hari)
   - Pengendalian Hama (30 hari)
   - Monitoring Kesehatan (14 hari)
   - Pemberian Mulsa (120 hari)

5. USERS (12 users dengan berbagai role):
   - 2 Admin
   - 2 Sales  
   - 3 Leader Area (1 per area)
   - 5 Pekerja

6. TREES (10 pohon dengan variasi):
   - 3 Durian di Medan (young stage)
   - 3 Mangga di Cirebon (mature stage) 
   - 2 Rambutan di Yogya (mature stage)
   - 2 Kelengkeng mixed areas (young stage)

7. CARE RECORDS (7 records perawatan):
   - Covering berbagai jenis aktivitas
   - Realistic duration dan cost
   - Proper before/after conditions

8. HARVEST RECORDS (4 records panen):
   - Hanya dari pohon mature
   - Realistic quantity dan pricing
   - Quality grades bervariasi

9. OPERATIONAL COSTS (6 records biaya):
   - Tools, materials, labor, maintenance
   - Realistic pricing dalam IDR
   - Proper approval workflow

10. NOTIFICATIONS (6 notifikasi):
    - Berbagai jenis untuk berbagai role
    - Priority levels bervariasi
    - Scheduled dan expiration dates

11. REPORTS (2 sample reports):
    - Weekly care summary
    - Monthly harvest report
    - Dengan data dan summary stats

Semua data menggunakan:
- Koordinat GPS asli Indonesia
- Nama lokal Indonesia
- Pricing realistis dalam IDR
- Praktek perkebunan Indonesia
- UUID yang konsisten untuk relasi
*/