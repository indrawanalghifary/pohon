export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instanciate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "12.2.3 (519615d)"
  }
  public: {
    Tables: {
      areas: {
        Row: {
          climate_zone: string | null
          code: string
          coordinates: Json | null
          created_at: string | null
          description: string | null
          id: string
          is_active: boolean | null
          location: string | null
          manager_id: string | null
          name: string
          soil_type: string | null
          total_area: number | null
          updated_at: string | null
        }
        Insert: {
          climate_zone?: string | null
          code: string
          coordinates?: Json | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          location?: string | null
          manager_id?: string | null
          name: string
          soil_type?: string | null
          total_area?: number | null
          updated_at?: string | null
        }
        Update: {
          climate_zone?: string | null
          code?: string
          coordinates?: Json | null
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          location?: string | null
          manager_id?: string | null
          name?: string
          soil_type?: string | null
          total_area?: number | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "areas_manager_id_fkey"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_areas_manager"
            columns: ["manager_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      audit_logs: {
        Row: {
          action: string
          additional_info: Json | null
          changed_fields: string[] | null
          created_at: string | null
          entity_id: string | null
          entity_type: string
          id: string
          ip_address: unknown | null
          new_values: Json | null
          old_values: Json | null
          request_id: string | null
          session_id: string | null
          severity: string | null
          user_agent: string | null
          user_id: string | null
        }
        Insert: {
          action: string
          additional_info?: Json | null
          changed_fields?: string[] | null
          created_at?: string | null
          entity_id?: string | null
          entity_type: string
          id?: string
          ip_address?: unknown | null
          new_values?: Json | null
          old_values?: Json | null
          request_id?: string | null
          session_id?: string | null
          severity?: string | null
          user_agent?: string | null
          user_id?: string | null
        }
        Update: {
          action?: string
          additional_info?: Json | null
          changed_fields?: string[] | null
          created_at?: string | null
          entity_id?: string | null
          entity_type?: string
          id?: string
          ip_address?: unknown | null
          new_values?: Json | null
          old_values?: Json | null
          request_id?: string | null
          session_id?: string | null
          severity?: string | null
          user_agent?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "audit_logs_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_audit_logs_user"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      care_activities: {
        Row: {
          category: string | null
          created_at: string | null
          description: string | null
          estimated_duration_minutes: number | null
          frequency_days: number | null
          id: string
          instructions: string | null
          is_active: boolean | null
          name: string
          required_tools: string | null
          safety_notes: string | null
          updated_at: string | null
        }
        Insert: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          estimated_duration_minutes?: number | null
          frequency_days?: number | null
          id?: string
          instructions?: string | null
          is_active?: boolean | null
          name: string
          required_tools?: string | null
          safety_notes?: string | null
          updated_at?: string | null
        }
        Update: {
          category?: string | null
          created_at?: string | null
          description?: string | null
          estimated_duration_minutes?: number | null
          frequency_days?: number | null
          id?: string
          instructions?: string | null
          is_active?: boolean | null
          name?: string
          required_tools?: string | null
          safety_notes?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      harvest_records: {
        Row: {
          buyer_info: string | null
          created_at: string | null
          harvest_date: string
          harvested_by: string
          id: string
          market_price_per_unit: number | null
          notes: string | null
          quality_grade: string | null
          quantity: number
          storage_location: string | null
          total_value: number | null
          tree_id: string
          unit: string
          updated_at: string | null
        }
        Insert: {
          buyer_info?: string | null
          created_at?: string | null
          harvest_date: string
          harvested_by: string
          id?: string
          market_price_per_unit?: number | null
          notes?: string | null
          quality_grade?: string | null
          quantity: number
          storage_location?: string | null
          total_value?: number | null
          tree_id: string
          unit: string
          updated_at?: string | null
        }
        Update: {
          buyer_info?: string | null
          created_at?: string | null
          harvest_date?: string
          harvested_by?: string
          id?: string
          market_price_per_unit?: number | null
          notes?: string | null
          quality_grade?: string | null
          quantity?: number
          storage_location?: string | null
          total_value?: number | null
          tree_id?: string
          unit?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_harvest_records_harvested_by"
            columns: ["harvested_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_harvest_records_tree"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "harvest_records_harvested_by_fkey"
            columns: ["harvested_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "harvest_records_tree_id_fkey"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
        ]
      }
      notifications: {
        Row: {
          action_required: boolean | null
          action_url: string | null
          created_at: string | null
          expires_at: string | null
          id: string
          is_read: boolean | null
          message: string
          priority: string | null
          read_at: string | null
          related_entity_id: string | null
          related_entity_type: string | null
          scheduled_for: string | null
          sent_at: string | null
          title: string
          type: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          action_required?: boolean | null
          action_url?: string | null
          created_at?: string | null
          expires_at?: string | null
          id?: string
          is_read?: boolean | null
          message: string
          priority?: string | null
          read_at?: string | null
          related_entity_id?: string | null
          related_entity_type?: string | null
          scheduled_for?: string | null
          sent_at?: string | null
          title: string
          type: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          action_required?: boolean | null
          action_url?: string | null
          created_at?: string | null
          expires_at?: string | null
          id?: string
          is_read?: boolean | null
          message?: string
          priority?: string | null
          read_at?: string | null
          related_entity_id?: string | null
          related_entity_type?: string | null
          scheduled_for?: string | null
          sent_at?: string | null
          title?: string
          type?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fk_notifications_user"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "notifications_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      operational_costs: {
        Row: {
          additional_info: Json | null
          amount: number
          approved_by: string | null
          area_id: string | null
          category: string
          created_at: string | null
          currency: string | null
          date: string
          description: string
          id: string
          invoice_number: string | null
          is_recurring: boolean | null
          paid_by: string | null
          payment_method: string | null
          receipt_url: string | null
          recurrence_pattern: string | null
          status: string | null
          subcategory: string | null
          tree_id: string | null
          updated_at: string | null
          vendor_name: string | null
        }
        Insert: {
          additional_info?: Json | null
          amount: number
          approved_by?: string | null
          area_id?: string | null
          category: string
          created_at?: string | null
          currency?: string | null
          date: string
          description: string
          id?: string
          invoice_number?: string | null
          is_recurring?: boolean | null
          paid_by?: string | null
          payment_method?: string | null
          receipt_url?: string | null
          recurrence_pattern?: string | null
          status?: string | null
          subcategory?: string | null
          tree_id?: string | null
          updated_at?: string | null
          vendor_name?: string | null
        }
        Update: {
          additional_info?: Json | null
          amount?: number
          approved_by?: string | null
          area_id?: string | null
          category?: string
          created_at?: string | null
          currency?: string | null
          date?: string
          description?: string
          id?: string
          invoice_number?: string | null
          is_recurring?: boolean | null
          paid_by?: string | null
          payment_method?: string | null
          receipt_url?: string | null
          recurrence_pattern?: string | null
          status?: string | null
          subcategory?: string | null
          tree_id?: string | null
          updated_at?: string | null
          vendor_name?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_operational_costs_approved_by"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_operational_costs_area"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_operational_costs_paid_by"
            columns: ["paid_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_operational_costs_tree"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "operational_costs_approved_by_fkey"
            columns: ["approved_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "operational_costs_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "operational_costs_paid_by_fkey"
            columns: ["paid_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "operational_costs_tree_id_fkey"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
        ]
      }
      photos: {
        Row: {
          caption: string | null
          coordinates: Json | null
          created_at: string | null
          file_path: string
          file_size_bytes: number | null
          file_url: string
          filename: string
          height_px: number | null
          id: string
          is_primary: boolean | null
          is_public: boolean | null
          mime_type: string | null
          original_filename: string | null
          photo_type: string | null
          related_entity_id: string
          related_entity_type: string
          tags: string[] | null
          taken_at: string | null
          updated_at: string | null
          uploaded_by: string
          weather_condition: string | null
          width_px: number | null
        }
        Insert: {
          caption?: string | null
          coordinates?: Json | null
          created_at?: string | null
          file_path: string
          file_size_bytes?: number | null
          file_url: string
          filename: string
          height_px?: number | null
          id?: string
          is_primary?: boolean | null
          is_public?: boolean | null
          mime_type?: string | null
          original_filename?: string | null
          photo_type?: string | null
          related_entity_id: string
          related_entity_type: string
          tags?: string[] | null
          taken_at?: string | null
          updated_at?: string | null
          uploaded_by: string
          weather_condition?: string | null
          width_px?: number | null
        }
        Update: {
          caption?: string | null
          coordinates?: Json | null
          created_at?: string | null
          file_path?: string
          file_size_bytes?: number | null
          file_url?: string
          filename?: string
          height_px?: number | null
          id?: string
          is_primary?: boolean | null
          is_public?: boolean | null
          mime_type?: string | null
          original_filename?: string | null
          photo_type?: string | null
          related_entity_id?: string
          related_entity_type?: string
          tags?: string[] | null
          taken_at?: string | null
          updated_at?: string | null
          uploaded_by?: string
          weather_condition?: string | null
          width_px?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_photos_uploaded_by"
            columns: ["uploaded_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "photos_uploaded_by_fkey"
            columns: ["uploaded_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      reports: {
        Row: {
          area_id: string | null
          category: string | null
          created_at: string | null
          data: Json | null
          date_from: string
          date_to: string
          description: string | null
          file_format: string | null
          file_url: string | null
          generated_by: string
          id: string
          is_scheduled: boolean | null
          next_generation_date: string | null
          parameters: Json | null
          schedule_pattern: string | null
          status: string | null
          summary_stats: Json | null
          title: string
          type: string
          updated_at: string | null
        }
        Insert: {
          area_id?: string | null
          category?: string | null
          created_at?: string | null
          data?: Json | null
          date_from: string
          date_to: string
          description?: string | null
          file_format?: string | null
          file_url?: string | null
          generated_by: string
          id?: string
          is_scheduled?: boolean | null
          next_generation_date?: string | null
          parameters?: Json | null
          schedule_pattern?: string | null
          status?: string | null
          summary_stats?: Json | null
          title: string
          type: string
          updated_at?: string | null
        }
        Update: {
          area_id?: string | null
          category?: string | null
          created_at?: string | null
          data?: Json | null
          date_from?: string
          date_to?: string
          description?: string | null
          file_format?: string | null
          file_url?: string | null
          generated_by?: string
          id?: string
          is_scheduled?: boolean | null
          next_generation_date?: string | null
          parameters?: Json | null
          schedule_pattern?: string | null
          status?: string | null
          summary_stats?: Json | null
          title?: string
          type?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_reports_area"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_reports_generated_by"
            columns: ["generated_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reports_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "reports_generated_by_fkey"
            columns: ["generated_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      tree_care_records: {
        Row: {
          after_condition: string | null
          before_condition: string | null
          care_activity_id: string
          cost_amount: number | null
          created_at: string | null
          duration_minutes: number | null
          id: string
          is_scheduled: boolean | null
          materials_used: Json | null
          notes: string | null
          performed_at: string
          performed_by: string
          tree_id: string
          updated_at: string | null
          weather_condition: string | null
        }
        Insert: {
          after_condition?: string | null
          before_condition?: string | null
          care_activity_id: string
          cost_amount?: number | null
          created_at?: string | null
          duration_minutes?: number | null
          id?: string
          is_scheduled?: boolean | null
          materials_used?: Json | null
          notes?: string | null
          performed_at: string
          performed_by: string
          tree_id: string
          updated_at?: string | null
          weather_condition?: string | null
        }
        Update: {
          after_condition?: string | null
          before_condition?: string | null
          care_activity_id?: string
          cost_amount?: number | null
          created_at?: string | null
          duration_minutes?: number | null
          id?: string
          is_scheduled?: boolean | null
          materials_used?: Json | null
          notes?: string | null
          performed_at?: string
          performed_by?: string
          tree_id?: string
          updated_at?: string | null
          weather_condition?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_care_records_activity"
            columns: ["care_activity_id"]
            isOneToOne: false
            referencedRelation: "care_activities"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_care_records_performed_by"
            columns: ["performed_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_care_records_tree"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tree_care_records_care_activity_id_fkey"
            columns: ["care_activity_id"]
            isOneToOne: false
            referencedRelation: "care_activities"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tree_care_records_performed_by_fkey"
            columns: ["performed_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tree_care_records_tree_id_fkey"
            columns: ["tree_id"]
            isOneToOne: false
            referencedRelation: "trees"
            referencedColumns: ["id"]
          },
        ]
      }
      tree_types: {
        Row: {
          average_height_meters: number | null
          care_instructions: string | null
          category: string | null
          climate_requirements: string | null
          created_at: string | null
          description: string | null
          harvest_season: string | null
          id: string
          is_active: boolean | null
          local_name: string | null
          maturity_period_months: number | null
          name: string
          planting_season: string | null
          scientific_name: string | null
          soil_requirements: string | null
          updated_at: string | null
        }
        Insert: {
          average_height_meters?: number | null
          care_instructions?: string | null
          category?: string | null
          climate_requirements?: string | null
          created_at?: string | null
          description?: string | null
          harvest_season?: string | null
          id?: string
          is_active?: boolean | null
          local_name?: string | null
          maturity_period_months?: number | null
          name: string
          planting_season?: string | null
          scientific_name?: string | null
          soil_requirements?: string | null
          updated_at?: string | null
        }
        Update: {
          average_height_meters?: number | null
          care_instructions?: string | null
          category?: string | null
          climate_requirements?: string | null
          created_at?: string | null
          description?: string | null
          harvest_season?: string | null
          id?: string
          is_active?: boolean | null
          local_name?: string | null
          maturity_period_months?: number | null
          name?: string
          planting_season?: string | null
          scientific_name?: string | null
          soil_requirements?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      trees: {
        Row: {
          area_id: string
          coordinates: Json | null
          created_at: string | null
          current_diameter_cm: number | null
          current_height_cm: number | null
          growth_stage: string | null
          health_status: string | null
          id: string
          is_active: boolean | null
          notes: string | null
          planted_by: string | null
          planting_date: string
          tree_code: string
          tree_type_id: string
          updated_at: string | null
        }
        Insert: {
          area_id: string
          coordinates?: Json | null
          created_at?: string | null
          current_diameter_cm?: number | null
          current_height_cm?: number | null
          growth_stage?: string | null
          health_status?: string | null
          id?: string
          is_active?: boolean | null
          notes?: string | null
          planted_by?: string | null
          planting_date: string
          tree_code: string
          tree_type_id: string
          updated_at?: string | null
        }
        Update: {
          area_id?: string
          coordinates?: Json | null
          created_at?: string | null
          current_diameter_cm?: number | null
          current_height_cm?: number | null
          growth_stage?: string | null
          health_status?: string | null
          id?: string
          is_active?: boolean | null
          notes?: string | null
          planted_by?: string | null
          planting_date?: string
          tree_code?: string
          tree_type_id?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_trees_area"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_trees_planted_by"
            columns: ["planted_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_trees_type"
            columns: ["tree_type_id"]
            isOneToOne: false
            referencedRelation: "tree_types"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trees_area_id_fkey"
            columns: ["area_id"]
            isOneToOne: false
            referencedRelation: "areas"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trees_planted_by_fkey"
            columns: ["planted_by"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "trees_tree_type_id_fkey"
            columns: ["tree_type_id"]
            isOneToOne: false
            referencedRelation: "tree_types"
            referencedColumns: ["id"]
          },
        ]
      }
      user_roles: {
        Row: {
          created_at: string | null
          description: string | null
          id: string
          is_active: boolean | null
          name: string
          permissions: Json | null
          updated_at: string | null
        }
        Insert: {
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          name: string
          permissions?: Json | null
          updated_at?: string | null
        }
        Update: {
          created_at?: string | null
          description?: string | null
          id?: string
          is_active?: boolean | null
          name?: string
          permissions?: Json | null
          updated_at?: string | null
        }
        Relationships: []
      }
      users: {
        Row: {
          avatar_url: string | null
          created_at: string | null
          department: string | null
          email: string
          employee_id: string | null
          hire_date: string | null
          id: string
          is_active: boolean | null
          last_login_at: string | null
          name: string
          phone: string | null
          role_id: string | null
          updated_at: string | null
        }
        Insert: {
          avatar_url?: string | null
          created_at?: string | null
          department?: string | null
          email: string
          employee_id?: string | null
          hire_date?: string | null
          id: string
          is_active?: boolean | null
          last_login_at?: string | null
          name: string
          phone?: string | null
          role_id?: string | null
          updated_at?: string | null
        }
        Update: {
          avatar_url?: string | null
          created_at?: string | null
          department?: string | null
          email?: string
          employee_id?: string | null
          hire_date?: string | null
          id?: string
          is_active?: boolean | null
          last_login_at?: string | null
          name?: string
          phone?: string | null
          role_id?: string | null
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fk_users_role"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "user_roles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "users_role_id_fkey"
            columns: ["role_id"]
            isOneToOne: false
            referencedRelation: "user_roles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      analyze_productivity: {
        Args: { area_uuid?: string }
        Returns: {
          area_name: string
          total_trees: number
          productive_trees: number
          productivity_percentage: number
          total_harvest_value: number
          average_value_per_tree: number
        }[]
      }
      auth_user_role: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
      calculate_next_care_due_date: {
        Args: { tree_uuid: string; care_activity_uuid: string }
        Returns: string
      }
      calculate_roi: {
        Args: {
          entity_type: string
          entity_uuid: string
          date_from?: string
          date_to?: string
        }
        Returns: number
      }
      calculate_tree_age_months: {
        Args: { planting_date: string }
        Returns: number
      }
      calculate_tree_costs: {
        Args: { tree_uuid: string; date_from?: string; date_to?: string }
        Returns: number
      }
      daily_notification_cleanup: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      generate_automatic_report: {
        Args: { report_type: string; area_uuid?: string }
        Returns: string
      }
      generate_report_data: {
        Args: {
          report_type: string
          area_uuid?: string
          date_from?: string
          date_to?: string
        }
        Returns: Json
      }
      generate_tree_barcode: {
        Args: Record<PropertyKey, never>
        Returns: string
      }
      get_care_activity_summary: {
        Args: { area_uuid?: string; date_from?: string; date_to?: string }
        Returns: {
          activity_name: string
          activity_count: number
          total_cost: number
          average_duration: number
          trees_affected: number
        }[]
      }
      get_harvest_summary: {
        Args: { area_uuid?: string; date_from?: string; date_to?: string }
        Returns: {
          tree_type_name: string
          total_quantity: number
          total_value: number
          average_price: number
          harvest_count: number
        }[]
      }
      get_overdue_care_activities: {
        Args: { area_uuid?: string }
        Returns: {
          tree_id: string
          tree_code: string
          care_activity_id: string
          care_activity_name: string
          due_date: string
          days_overdue: number
        }[]
      }
      get_tree_productivity_rating: {
        Args: { tree_uuid: string }
        Returns: string
      }
      has_area_access: {
        Args: { area_uuid: string }
        Returns: boolean
      }
      has_permission: {
        Args: { permission_name: string }
        Returns: boolean
      }
      is_admin: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      monthly_productivity_reports: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      quarterly_cost_analysis: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
      tree_needs_care: {
        Args: { tree_uuid: string; care_activity_uuid: string }
        Returns: boolean
      }
      user_managed_areas: {
        Args: Record<PropertyKey, never>
        Returns: string[]
      }
      validate_coordinates: {
        Args: { coordinates: Json }
        Returns: boolean
      }
      validate_harvest_quantity: {
        Args: { tree_uuid: string; quantity: number; harvest_date: string }
        Returns: boolean
      }
      validate_planting_date: {
        Args: { planting_date: string }
        Returns: boolean
      }
      weekly_care_due_notifications: {
        Args: Record<PropertyKey, never>
        Returns: undefined
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
