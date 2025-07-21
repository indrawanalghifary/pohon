-- =============================================
-- Aplikasi Manajemen Pohon - Constraints & Indexes
-- =============================================

-- Foreign Key Constraints
-- =============================================

-- Users constraints
ALTER TABLE users ADD CONSTRAINT fk_users_role 
  FOREIGN KEY (role_id) REFERENCES user_roles(id);

-- Areas constraints  
ALTER TABLE areas ADD CONSTRAINT fk_areas_manager 
  FOREIGN KEY (manager_id) REFERENCES users(id);

-- Trees constraints
ALTER TABLE trees ADD CONSTRAINT fk_trees_type 
  FOREIGN KEY (tree_type_id) REFERENCES tree_types(id);

ALTER TABLE trees ADD CONSTRAINT fk_trees_area 
  FOREIGN KEY (area_id) REFERENCES areas(id);

ALTER TABLE trees ADD CONSTRAINT fk_trees_planted_by 
  FOREIGN KEY (planted_by) REFERENCES users(id);

-- Tree care records constraints
ALTER TABLE tree_care_records ADD CONSTRAINT fk_care_records_tree 
  FOREIGN KEY (tree_id) REFERENCES trees(id) ON DELETE CASCADE;

ALTER TABLE tree_care_records ADD CONSTRAINT fk_care_records_activity 
  FOREIGN KEY (care_activity_id) REFERENCES care_activities(id);

ALTER TABLE tree_care_records ADD CONSTRAINT fk_care_records_performed_by 
  FOREIGN KEY (performed_by) REFERENCES users(id);

-- Harvest records constraints
ALTER TABLE harvest_records ADD CONSTRAINT fk_harvest_records_tree 
  FOREIGN KEY (tree_id) REFERENCES trees(id) ON DELETE CASCADE;

ALTER TABLE harvest_records ADD CONSTRAINT fk_harvest_records_harvested_by 
  FOREIGN KEY (harvested_by) REFERENCES users(id);

-- Operational costs constraints
ALTER TABLE operational_costs ADD CONSTRAINT fk_operational_costs_area 
  FOREIGN KEY (area_id) REFERENCES areas(id);

ALTER TABLE operational_costs ADD CONSTRAINT fk_operational_costs_tree 
  FOREIGN KEY (tree_id) REFERENCES trees(id);

ALTER TABLE operational_costs ADD CONSTRAINT fk_operational_costs_paid_by 
  FOREIGN KEY (paid_by) REFERENCES users(id);

ALTER TABLE operational_costs ADD CONSTRAINT fk_operational_costs_approved_by 
  FOREIGN KEY (approved_by) REFERENCES users(id);

-- Notifications constraints
ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user 
  FOREIGN KEY (user_id) REFERENCES users(id);

-- Reports constraints
ALTER TABLE reports ADD CONSTRAINT fk_reports_generated_by 
  FOREIGN KEY (generated_by) REFERENCES users(id);

ALTER TABLE reports ADD CONSTRAINT fk_reports_area 
  FOREIGN KEY (area_id) REFERENCES areas(id);

-- Photos constraints
ALTER TABLE photos ADD CONSTRAINT fk_photos_uploaded_by 
  FOREIGN KEY (uploaded_by) REFERENCES users(id);

-- Audit logs constraints
ALTER TABLE audit_logs ADD CONSTRAINT fk_audit_logs_user 
  FOREIGN KEY (user_id) REFERENCES users(id);

-- Performance Indexes
-- =============================================

-- Users indexes
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_employee_id ON users(employee_id);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_users_last_login ON users(last_login_at);

-- Areas indexes
CREATE INDEX idx_areas_manager_id ON areas(manager_id);
CREATE INDEX idx_areas_code ON areas(code);
CREATE INDEX idx_areas_is_active ON areas(is_active);

-- Tree types indexes
CREATE INDEX idx_tree_types_category ON tree_types(category);
CREATE INDEX idx_tree_types_is_active ON tree_types(is_active);

-- Trees indexes
CREATE INDEX idx_trees_area_id ON trees(area_id);
CREATE INDEX idx_trees_tree_type_id ON trees(tree_type_id);
CREATE INDEX idx_trees_planted_by ON trees(planted_by);
CREATE INDEX idx_trees_health_status ON trees(health_status);
CREATE INDEX idx_trees_growth_stage ON trees(growth_stage);
CREATE INDEX idx_trees_planting_date ON trees(planting_date);
CREATE INDEX idx_trees_is_active ON trees(is_active);
CREATE INDEX idx_trees_tree_code ON trees(tree_code);

-- Composite indexes for trees
CREATE INDEX idx_trees_area_health ON trees(area_id, health_status);
CREATE INDEX idx_trees_area_type ON trees(area_id, tree_type_id);
CREATE INDEX idx_trees_status_stage ON trees(health_status, growth_stage);

-- Care activities indexes
CREATE INDEX idx_care_activities_category ON care_activities(category);
CREATE INDEX idx_care_activities_is_active ON care_activities(is_active);

-- Tree care records indexes
CREATE INDEX idx_care_records_tree_id ON tree_care_records(tree_id);
CREATE INDEX idx_care_records_activity_id ON tree_care_records(care_activity_id);
CREATE INDEX idx_care_records_performed_by ON tree_care_records(performed_by);
CREATE INDEX idx_care_records_performed_at ON tree_care_records(performed_at);
CREATE INDEX idx_care_records_is_scheduled ON tree_care_records(is_scheduled);

-- Composite indexes for care records
CREATE INDEX idx_care_records_tree_date ON tree_care_records(tree_id, performed_at);
CREATE INDEX idx_care_records_user_date ON tree_care_records(performed_by, performed_at);

-- Harvest records indexes
CREATE INDEX idx_harvest_records_tree_id ON harvest_records(tree_id);
CREATE INDEX idx_harvest_records_harvested_by ON harvest_records(harvested_by);
CREATE INDEX idx_harvest_records_harvest_date ON harvest_records(harvest_date);
CREATE INDEX idx_harvest_records_quality_grade ON harvest_records(quality_grade);

-- Composite indexes for harvest records
CREATE INDEX idx_harvest_records_tree_date ON harvest_records(tree_id, harvest_date);
CREATE INDEX idx_harvest_records_date_quality ON harvest_records(harvest_date, quality_grade);

-- Operational costs indexes
CREATE INDEX idx_operational_costs_category ON operational_costs(category);
CREATE INDEX idx_operational_costs_date ON operational_costs(date);
CREATE INDEX idx_operational_costs_area_id ON operational_costs(area_id);
CREATE INDEX idx_operational_costs_tree_id ON operational_costs(tree_id);
CREATE INDEX idx_operational_costs_status ON operational_costs(status);
CREATE INDEX idx_operational_costs_paid_by ON operational_costs(paid_by);

-- Composite indexes for operational costs
CREATE INDEX idx_operational_costs_area_date ON operational_costs(area_id, date);
CREATE INDEX idx_operational_costs_category_date ON operational_costs(category, date);

-- Notifications indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_priority ON notifications(priority);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_scheduled_for ON notifications(scheduled_for);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

-- Composite indexes for notifications
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_user_type ON notifications(user_id, type);
CREATE INDEX idx_notifications_priority_read ON notifications(priority, is_read);

-- Reports indexes
CREATE INDEX idx_reports_generated_by ON reports(generated_by);
CREATE INDEX idx_reports_area_id ON reports(area_id);
CREATE INDEX idx_reports_type ON reports(type);
CREATE INDEX idx_reports_category ON reports(category);
CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_created_at ON reports(created_at);

-- Composite indexes for reports
CREATE INDEX idx_reports_type_status ON reports(type, status);
CREATE INDEX idx_reports_area_date ON reports(area_id, date_from, date_to);

-- Photos indexes
CREATE INDEX idx_photos_uploaded_by ON photos(uploaded_by);
CREATE INDEX idx_photos_entity_type ON photos(related_entity_type);
CREATE INDEX idx_photos_entity_id ON photos(related_entity_id);
CREATE INDEX idx_photos_photo_type ON photos(photo_type);
CREATE INDEX idx_photos_is_primary ON photos(is_primary);
CREATE INDEX idx_photos_taken_at ON photos(taken_at);

-- Composite indexes for photos
CREATE INDEX idx_photos_entity ON photos(related_entity_type, related_entity_id);
CREATE INDEX idx_photos_entity_primary ON photos(related_entity_type, related_entity_id, is_primary);

-- Audit logs indexes
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX idx_audit_logs_entity_id ON audit_logs(entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_severity ON audit_logs(severity);

-- Composite indexes for audit logs
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_user_action ON audit_logs(user_id, action);

-- Additional Check Constraints
-- =============================================

-- Trees additional constraints
ALTER TABLE trees ADD CONSTRAINT chk_tree_height_positive 
  CHECK (current_height_cm IS NULL OR current_height_cm > 0);

ALTER TABLE trees ADD CONSTRAINT chk_tree_diameter_positive 
  CHECK (current_diameter_cm IS NULL OR current_diameter_cm > 0);

-- Tree care records constraints
ALTER TABLE tree_care_records ADD CONSTRAINT chk_care_duration_positive 
  CHECK (duration_minutes IS NULL OR duration_minutes > 0);

ALTER TABLE tree_care_records ADD CONSTRAINT chk_care_cost_positive 
  CHECK (cost_amount IS NULL OR cost_amount >= 0);

ALTER TABLE tree_care_records ADD CONSTRAINT chk_care_performed_date 
  CHECK (performed_at <= NOW());

-- Harvest records constraints
ALTER TABLE harvest_records ADD CONSTRAINT chk_harvest_quantity_positive 
  CHECK (quantity > 0);

ALTER TABLE harvest_records ADD CONSTRAINT chk_harvest_price_positive 
  CHECK (market_price_per_unit IS NULL OR market_price_per_unit >= 0);

ALTER TABLE harvest_records ADD CONSTRAINT chk_harvest_value_positive 
  CHECK (total_value IS NULL OR total_value >= 0);

ALTER TABLE harvest_records ADD CONSTRAINT chk_harvest_quality_grade 
  CHECK (quality_grade IS NULL OR quality_grade IN ('A', 'B', 'C', 'Premium', 'Standard', 'Low'));

ALTER TABLE harvest_records ADD CONSTRAINT chk_harvest_date_valid 
  CHECK (harvest_date <= CURRENT_DATE);

-- Operational costs constraints
ALTER TABLE operational_costs ADD CONSTRAINT chk_operational_amount_positive 
  CHECK (amount > 0);

ALTER TABLE operational_costs ADD CONSTRAINT chk_operational_date_valid 
  CHECK (date <= CURRENT_DATE);

ALTER TABLE operational_costs ADD CONSTRAINT chk_operational_currency 
  CHECK (currency IN ('IDR', 'USD', 'EUR'));

-- Tree types constraints
ALTER TABLE tree_types ADD CONSTRAINT chk_tree_type_maturity_positive 
  CHECK (maturity_period_months IS NULL OR maturity_period_months > 0);

ALTER TABLE tree_types ADD CONSTRAINT chk_tree_type_height_positive 
  CHECK (average_height_meters IS NULL OR average_height_meters > 0);

ALTER TABLE tree_types ADD CONSTRAINT chk_tree_type_category 
  CHECK (category IS NULL OR category IN ('Buah', 'Kayu', 'Hias', 'Obat', 'Rempah', 'Sayuran', 'Lainnya'));

-- Areas constraints
ALTER TABLE areas ADD CONSTRAINT chk_area_total_area_positive 
  CHECK (total_area IS NULL OR total_area > 0);

-- Care activities constraints
ALTER TABLE care_activities ADD CONSTRAINT chk_care_frequency_positive 
  CHECK (frequency_days IS NULL OR frequency_days > 0);

ALTER TABLE care_activities ADD CONSTRAINT chk_care_duration_positive 
  CHECK (estimated_duration_minutes IS NULL OR estimated_duration_minutes > 0);

ALTER TABLE care_activities ADD CONSTRAINT chk_care_category 
  CHECK (category IS NULL OR category IN ('Penyiraman', 'Pemupukan', 'Pemangkasan', 'Penyiangan', 'Pengendalian Hama', 'Monitoring', 'Lainnya'));

-- Photos constraints
ALTER TABLE photos ADD CONSTRAINT chk_photo_file_size_positive 
  CHECK (file_size_bytes IS NULL OR file_size_bytes > 0);

ALTER TABLE photos ADD CONSTRAINT chk_photo_dimensions_positive 
  CHECK ((width_px IS NULL OR width_px > 0) AND (height_px IS NULL OR height_px > 0));

ALTER TABLE photos ADD CONSTRAINT chk_photo_entity_type 
  CHECK (related_entity_type IN ('tree', 'area', 'care_record', 'harvest_record', 'user', 'report'));

ALTER TABLE photos ADD CONSTRAINT chk_photo_type 
  CHECK (photo_type IS NULL OR photo_type IN ('before', 'after', 'progress', 'condition', 'documentation', 'profile'));

-- Notifications constraints
ALTER TABLE notifications ADD CONSTRAINT chk_notification_type 
  CHECK (type IN ('care_reminder', 'harvest_time', 'maintenance_due', 'alert', 'system', 'report_ready'));

ALTER TABLE notifications ADD CONSTRAINT chk_notification_entity_type 
  CHECK (related_entity_type IS NULL OR related_entity_type IN ('tree', 'area', 'care_record', 'harvest_record', 'report', 'user'));

ALTER TABLE notifications ADD CONSTRAINT chk_notification_dates 
  CHECK (expires_at IS NULL OR expires_at > created_at);

-- Reports constraints  
ALTER TABLE reports ADD CONSTRAINT chk_report_date_range 
  CHECK (date_to >= date_from);

ALTER TABLE reports ADD CONSTRAINT chk_report_type 
  CHECK (type IN ('daily', 'weekly', 'monthly', 'quarterly', 'annual', 'custom'));

ALTER TABLE reports ADD CONSTRAINT chk_report_category 
  CHECK (category IS NULL OR category IN ('care_summary', 'harvest_report', 'cost_analysis', 'performance', 'maintenance', 'overview'));

ALTER TABLE reports ADD CONSTRAINT chk_report_format 
  CHECK (file_format IS NULL OR file_format IN ('pdf', 'xlsx', 'csv', 'json'));

-- Performance optimization indexes for JSON fields
-- =============================================

-- GIN indexes for JSONB fields (faster querying)
CREATE INDEX idx_user_roles_permissions_gin ON user_roles USING GIN (permissions);
CREATE INDEX idx_areas_coordinates_gin ON areas USING GIN (coordinates);
CREATE INDEX idx_trees_coordinates_gin ON trees USING GIN (coordinates);
CREATE INDEX idx_care_records_materials_gin ON tree_care_records USING GIN (materials_used);
CREATE INDEX idx_operational_costs_additional_gin ON operational_costs USING GIN (additional_info) WHERE additional_info IS NOT NULL;
CREATE INDEX idx_reports_parameters_gin ON reports USING GIN (parameters);
CREATE INDEX idx_reports_data_gin ON reports USING GIN (data);
CREATE INDEX idx_photos_coordinates_gin ON photos USING GIN (coordinates);
CREATE INDEX idx_audit_logs_old_values_gin ON audit_logs USING GIN (old_values);
CREATE INDEX idx_audit_logs_new_values_gin ON audit_logs USING GIN (new_values);

-- Partial indexes for better performance on filtered queries
-- =============================================

-- Active records only
CREATE INDEX idx_users_active_only ON users(id) WHERE is_active = true;
CREATE INDEX idx_areas_active_only ON areas(id) WHERE is_active = true;
CREATE INDEX idx_trees_active_only ON trees(id) WHERE is_active = true;
CREATE INDEX idx_tree_types_active_only ON tree_types(id) WHERE is_active = true;
CREATE INDEX idx_care_activities_active_only ON care_activities(id) WHERE is_active = true;

-- Unread notifications only
CREATE INDEX idx_notifications_unread ON notifications(user_id, created_at) WHERE is_read = false;

-- Primary photos only
CREATE INDEX idx_photos_primary_only ON photos(related_entity_type, related_entity_id) WHERE is_primary = true;

-- Pending/processing reports
CREATE INDEX idx_reports_pending ON reports(created_at) WHERE status IN ('generating', 'pending');

-- High priority notifications
CREATE INDEX idx_notifications_high_priority ON notifications(user_id, created_at) WHERE priority IN ('high', 'urgent');

-- =============================================
-- Constraints & Indexes Creation Complete
-- =============================================