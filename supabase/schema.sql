--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.5 (Ubuntu 17.5-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
begin
    raise debug 'PgBouncer auth request: %', p_usename;

    return query
    select 
        rolname::text, 
        case when rolvaliduntil < now() 
            then null 
            else rolpassword::text 
        end 
    from pg_authid 
    where rolname=$1 and rolcanlogin;
end;
$_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: analyze_productivity(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.analyze_productivity(area_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(area_name text, total_trees bigint, productive_trees bigint, productivity_percentage numeric, total_harvest_value numeric, average_value_per_tree numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    a.name as area_name,
    COUNT(t.id) as total_trees,
    COUNT(hr.tree_id) as productive_trees,
    ROUND((COUNT(hr.tree_id)::DECIMAL / NULLIF(COUNT(t.id), 0)) * 100, 2) as productivity_percentage,
    COALESCE(SUM(hr.total_value), 0) as total_harvest_value,
    COALESCE(AVG(hr.total_value), 0) as average_value_per_tree
  FROM areas a
  LEFT JOIN trees t ON a.id = t.area_id AND t.is_active = true
  LEFT JOIN harvest_records hr ON t.id = hr.tree_id 
    AND hr.harvest_date >= CURRENT_DATE - INTERVAL '12 months'
  WHERE (area_uuid IS NULL OR a.id = area_uuid)
    AND a.is_active = true
  GROUP BY a.id, a.name
  ORDER BY productivity_percentage DESC;
END;
$$;


ALTER FUNCTION public.analyze_productivity(area_uuid uuid) OWNER TO postgres;

--
-- Name: audit_trigger_function(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.audit_trigger_function() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  old_values JSONB := NULL;
  new_values JSONB := NULL;
  changed_fields TEXT[] := ARRAY[]::TEXT[];
  field_name TEXT;
BEGIN
  -- Determine action
  IF TG_OP = 'DELETE' THEN
    old_values := to_jsonb(OLD);
    INSERT INTO audit_logs (
      user_id, action, entity_type, entity_id,
      old_values, new_values, changed_fields
    ) VALUES (
      auth.uid(), TG_OP, TG_TABLE_NAME, OLD.id,
      old_values, NULL, ARRAY['*']
    );
    RETURN OLD;
    
  ELSIF TG_OP = 'INSERT' THEN
    new_values := to_jsonb(NEW);
    INSERT INTO audit_logs (
      user_id, action, entity_type, entity_id,
      old_values, new_values, changed_fields
    ) VALUES (
      auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id,
      NULL, new_values, ARRAY['*']
    );
    RETURN NEW;
    
  ELSIF TG_OP = 'UPDATE' THEN
    old_values := to_jsonb(OLD);
    new_values := to_jsonb(NEW);
    
    -- Find changed fields
    FOR field_name IN SELECT jsonb_object_keys(new_values) LOOP
      IF old_values->>field_name IS DISTINCT FROM new_values->>field_name THEN
        changed_fields := array_append(changed_fields, field_name);
      END IF;
    END LOOP;
    
    -- Only log if there are actual changes
    IF array_length(changed_fields, 1) > 0 THEN
      INSERT INTO audit_logs (
        user_id, action, entity_type, entity_id,
        old_values, new_values, changed_fields
      ) VALUES (
        auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id,
        old_values, new_values, changed_fields
      );
    END IF;
    
    RETURN NEW;
  END IF;
  
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.audit_trigger_function() OWNER TO postgres;

--
-- Name: FUNCTION audit_trigger_function(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.audit_trigger_function() IS 'Function trigger untuk audit trail semua perubahan data';


--
-- Name: auth_user_role(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auth_user_role() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_role_name TEXT;
BEGIN
  SELECT ur.name INTO user_role_name
  FROM users u
  JOIN user_roles ur ON u.role_id = ur.id
  WHERE u.id = auth.uid();
  
  RETURN COALESCE(user_role_name, 'guest');
END;
$$;


ALTER FUNCTION public.auth_user_role() OWNER TO postgres;

--
-- Name: FUNCTION auth_user_role(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.auth_user_role() IS 'Mengambil role name dari user yang sedang login';


--
-- Name: auto_generate_tree_barcode(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.auto_generate_tree_barcode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Generate barcode jika belum ada
  IF NEW.tree_code IS NULL OR NEW.tree_code = '' THEN
    NEW.tree_code := generate_tree_barcode();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_generate_tree_barcode() OWNER TO postgres;

--
-- Name: calculate_next_care_due_date(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
  frequency_days INTEGER;
  last_care_date DATE;
  next_due_date DATE;
BEGIN
  -- Ambil frequency dari care activity
  SELECT ca.frequency_days INTO frequency_days
  FROM care_activities ca
  WHERE ca.id = care_activity_uuid;
  
  -- Jika tidak ada frequency, return null
  IF frequency_days IS NULL THEN
    RETURN NULL;
  END IF;
  
  -- Ambil tanggal perawatan terakhir
  SELECT MAX(performed_at::DATE) INTO last_care_date
  FROM tree_care_records tcr
  WHERE tcr.tree_id = tree_uuid 
    AND tcr.care_activity_id = care_activity_uuid;
  
  -- Jika belum pernah ada perawatan, gunakan planting date
  IF last_care_date IS NULL THEN
    SELECT planting_date INTO last_care_date
    FROM trees
    WHERE id = tree_uuid;
  END IF;
  
  -- Calculate next due date
  next_due_date := last_care_date + INTERVAL '1 day' * frequency_days;
  
  RETURN next_due_date;
END;
$$;


ALTER FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) OWNER TO postgres;

--
-- Name: FUNCTION calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) IS 'Hitung tanggal jatuh tempo perawatan berikutnya berdasarkan frequency';


--
-- Name: calculate_roi(text, uuid, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_roi(entity_type text, entity_uuid uuid, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
  total_costs DECIMAL := 0;
  total_revenue DECIMAL := 0;
  roi_percentage DECIMAL;
BEGIN
  -- Set default dates
  IF date_from IS NULL THEN
    date_from := CURRENT_DATE - INTERVAL '12 months';
  END IF;
  
  IF date_to IS NULL THEN
    date_to := CURRENT_DATE;
  END IF;
  
  IF entity_type = 'tree' THEN
    -- Calculate costs untuk satu pohon
    total_costs := calculate_tree_costs(entity_uuid, date_from, date_to);
    
    -- Calculate revenue dari harvest
    SELECT COALESCE(SUM(total_value), 0) INTO total_revenue
    FROM harvest_records
    WHERE tree_id = entity_uuid
      AND harvest_date BETWEEN date_from AND date_to;
      
  ELSIF entity_type = 'area' THEN
    -- Calculate costs untuk area
    SELECT 
      COALESCE(SUM(oc.amount), 0) + 
      COALESCE(SUM(tcr.cost_amount), 0)
    INTO total_costs
    FROM areas a
    LEFT JOIN operational_costs oc ON a.id = oc.area_id 
      AND oc.date BETWEEN date_from AND date_to
      AND oc.status = 'paid'
    LEFT JOIN trees t ON a.id = t.area_id
    LEFT JOIN tree_care_records tcr ON t.id = tcr.tree_id
      AND tcr.performed_at::DATE BETWEEN date_from AND date_to
    WHERE a.id = entity_uuid;
    
    -- Calculate revenue dari harvest di area
    SELECT COALESCE(SUM(hr.total_value), 0) INTO total_revenue
    FROM harvest_records hr
    JOIN trees t ON hr.tree_id = t.id
    WHERE t.area_id = entity_uuid
      AND hr.harvest_date BETWEEN date_from AND date_to;
  ELSE
    RAISE EXCEPTION 'Invalid entity_type. Use tree or area.';
  END IF;
  
  -- Calculate ROI percentage
  IF total_costs > 0 THEN
    roi_percentage := ((total_revenue - total_costs) / total_costs) * 100;
  ELSE
    roi_percentage := CASE WHEN total_revenue > 0 THEN 100 ELSE 0 END;
  END IF;
  
  RETURN ROUND(roi_percentage, 2);
END;
$$;


ALTER FUNCTION public.calculate_roi(entity_type text, entity_uuid uuid, date_from date, date_to date) OWNER TO postgres;

--
-- Name: calculate_tree_age_months(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_tree_age_months(planting_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN EXTRACT(YEAR FROM age(CURRENT_DATE, planting_date)) * 12 + 
         EXTRACT(MONTH FROM age(CURRENT_DATE, planting_date));
END;
$$;


ALTER FUNCTION public.calculate_tree_age_months(planting_date date) OWNER TO postgres;

--
-- Name: FUNCTION calculate_tree_age_months(planting_date date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.calculate_tree_age_months(planting_date date) IS 'Hitung umur pohon dalam bulan dari tanggal tanam';


--
-- Name: calculate_tree_costs(uuid, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
  total_costs DECIMAL := 0;
  care_costs DECIMAL := 0;
  operational_costs DECIMAL := 0;
BEGIN
  -- Set default dates
  IF date_from IS NULL THEN
    SELECT planting_date INTO date_from FROM trees WHERE id = tree_uuid;
  END IF;
  
  IF date_to IS NULL THEN
    date_to := CURRENT_DATE;
  END IF;
  
  -- Hitung biaya perawatan langsung
  SELECT COALESCE(SUM(cost_amount), 0) INTO care_costs
  FROM tree_care_records
  WHERE tree_id = tree_uuid
    AND performed_at::DATE BETWEEN date_from AND date_to;
  
  -- Hitung biaya operasional yang terkait pohon
  SELECT COALESCE(SUM(amount), 0) INTO operational_costs
  FROM operational_costs
  WHERE tree_id = tree_uuid
    AND date BETWEEN date_from AND date_to
    AND status = 'paid';
  
  total_costs := care_costs + operational_costs;
  
  RETURN total_costs;
END;
$$;


ALTER FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date, date_to date) OWNER TO postgres;

--
-- Name: FUNCTION calculate_tree_costs(tree_uuid uuid, date_from date, date_to date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date, date_to date) IS 'Hitung total biaya operasional per pohon dalam periode tertentu';


--
-- Name: cleanup_expired_notifications_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cleanup_expired_notifications_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Delete expired notifications yang sudah read
  DELETE FROM notifications 
  WHERE expires_at < NOW() 
    AND is_read = true 
    AND created_at < NOW() - INTERVAL '30 days';
    
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.cleanup_expired_notifications_trigger() OWNER TO postgres;

--
-- Name: create_automatic_notification(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_automatic_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  notification_title TEXT;
  notification_message TEXT;
  notification_type TEXT;
  target_users UUID[];
  user_id UUID;
BEGIN
  -- Tentukan jenis notifikasi berdasarkan trigger
  IF TG_TABLE_NAME = 'trees' AND TG_OP = 'UPDATE' THEN
    -- Notifikasi untuk perubahan status pohon
    IF OLD.health_status != NEW.health_status THEN
      notification_type := 'alert';
      notification_title := 'Perubahan Status Kesehatan Pohon';
      notification_message := 'Pohon ' || NEW.tree_code || ' mengalami perubahan status dari ' || OLD.health_status || ' menjadi ' || NEW.health_status;
      
      -- Kirim ke manager area
      SELECT ARRAY[manager_id] INTO target_users
      FROM areas WHERE id = NEW.area_id AND manager_id IS NOT NULL;
    END IF;
    
  ELSIF TG_TABLE_NAME = 'tree_care_records' AND TG_OP = 'INSERT' THEN
    -- Notifikasi untuk care record baru
    notification_type := 'system';
    notification_title := 'Aktivitas Perawatan Dilakukan';
    SELECT 'Perawatan ' || ca.name || ' telah dilakukan pada pohon ' || t.tree_code
    INTO notification_message
    FROM trees t, care_activities ca
    WHERE t.id = NEW.tree_id AND ca.id = NEW.care_activity_id;
    
    -- Kirim ke manager area
    SELECT ARRAY[a.manager_id] INTO target_users
    FROM trees t
    JOIN areas a ON t.area_id = a.id
    WHERE t.id = NEW.tree_id AND a.manager_id IS NOT NULL;
    
  ELSIF TG_TABLE_NAME = 'harvest_records' AND TG_OP = 'INSERT' THEN
    -- Notifikasi untuk harvest baru
    notification_type := 'harvest_time';
    notification_title := 'Panen Berhasil Dilakukan';
    SELECT 'Panen sebesar ' || NEW.quantity || ' ' || NEW.unit || ' telah dilakukan pada pohon ' || t.tree_code
    INTO notification_message
    FROM trees t WHERE t.id = NEW.tree_id;
    
    -- Kirim ke manager area dan sales
    SELECT ARRAY_AGG(u.id) INTO target_users
    FROM users u
    JOIN user_roles ur ON u.role_id = ur.id
    WHERE ur.name IN ('Leader Area', 'Sales')
      AND (ur.name != 'Leader Area' OR u.id IN (
        SELECT a.manager_id FROM areas a 
        JOIN trees t ON a.id = t.area_id 
        WHERE t.id = NEW.tree_id
      ));
  END IF;
  
  -- Insert notifications untuk setiap target user
  IF target_users IS NOT NULL THEN
    FOREACH user_id IN ARRAY target_users LOOP
      INSERT INTO notifications (
        user_id, title, message, type, priority,
        related_entity_type, related_entity_id,
        scheduled_for, expires_at
      ) VALUES (
        user_id, notification_title, notification_message, notification_type, 'normal',
        TG_TABLE_NAME, COALESCE(NEW.id, OLD.id),
        NOW(), NOW() + INTERVAL '7 days'
      );
    END LOOP;
  END IF;
  
  RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.create_automatic_notification() OWNER TO postgres;

--
-- Name: daily_notification_cleanup(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.daily_notification_cleanup() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Delete expired notifications yang sudah read lebih dari 30 hari
  DELETE FROM notifications 
  WHERE expires_at < NOW() 
    AND is_read = true 
    AND read_at < NOW() - INTERVAL '30 days';
    
  -- Delete very old unread notifications (lebih dari 90 hari)
  DELETE FROM notifications 
  WHERE created_at < NOW() - INTERVAL '90 days'
    AND is_read = false;
    
  -- Log cleanup activity
  INSERT INTO audit_logs (action, entity_type, additional_info, severity)
  VALUES ('CLEANUP', 'notifications', 
    jsonb_build_object('action', 'daily_cleanup', 'timestamp', NOW()), 
    'info');
END;
$$;


ALTER FUNCTION public.daily_notification_cleanup() OWNER TO postgres;

--
-- Name: generate_automatic_report(text, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_automatic_report(report_type text, area_uuid uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  report_id UUID;
  report_title TEXT;
  date_from DATE;
  date_to DATE;
  report_data JSONB;
BEGIN
  report_id := uuid_generate_v4();
  date_to := CURRENT_DATE;
  
  CASE report_type
    WHEN 'daily' THEN
      date_from := CURRENT_DATE - INTERVAL '1 day';
      report_title := 'Laporan Harian - ' || to_char(CURRENT_DATE, 'DD/MM/YYYY');
    WHEN 'weekly' THEN
      date_from := CURRENT_DATE - INTERVAL '7 days';
      report_title := 'Laporan Mingguan - ' || to_char(CURRENT_DATE - INTERVAL '7 days', 'DD/MM') || ' s/d ' || to_char(CURRENT_DATE, 'DD/MM/YYYY');
    WHEN 'monthly' THEN
      date_from := date_trunc('month', CURRENT_DATE);
      report_title := 'Laporan Bulanan - ' || to_char(CURRENT_DATE, 'MM/YYYY');
    ELSE
      RAISE EXCEPTION 'Invalid report type: %', report_type;
  END CASE;
  
  -- Generate report data
  report_data := generate_report_data('care_summary', area_uuid, date_from, date_to);
  
  -- Insert report record
  INSERT INTO reports (
    id, title, type, category, description,
    generated_by, area_id, date_from, date_to,
    data, status, is_scheduled
  ) VALUES (
    report_id, report_title, report_type, 'care_summary',
    'Laporan otomatis yang dihasilkan sistem',
    (SELECT id FROM users WHERE email = 'system@pohon.app' LIMIT 1), -- System user
    area_uuid, date_from, date_to,
    report_data, 'completed', true
  );
  
  RETURN report_id;
END;
$$;


ALTER FUNCTION public.generate_automatic_report(report_type text, area_uuid uuid) OWNER TO postgres;

--
-- Name: generate_report_data(text, uuid, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_report_data(report_type text, area_uuid uuid DEFAULT NULL::uuid, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
  result JSONB := '{}';
  area_filter TEXT := '';
BEGIN
  -- Set default dates
  IF date_from IS NULL THEN
    date_from := CURRENT_DATE - INTERVAL '30 days';
  END IF;
  
  IF date_to IS NULL THEN
    date_to := CURRENT_DATE;
  END IF;
  
  -- Set area filter if specified
  IF area_uuid IS NOT NULL THEN
    area_filter := ' AND t.area_id = ''' || area_uuid || '''';
  END IF;
  
  CASE report_type
    WHEN 'care_summary' THEN
      result := jsonb_build_object(
        'total_activities', (
          SELECT COUNT(*)
          FROM tree_care_records tcr
          JOIN trees t ON tcr.tree_id = t.id
          WHERE tcr.performed_at::DATE BETWEEN date_from AND date_to
            AND (area_uuid IS NULL OR t.area_id = area_uuid)
        ),
        'total_cost', (
          SELECT COALESCE(SUM(tcr.cost_amount), 0)
          FROM tree_care_records tcr
          JOIN trees t ON tcr.tree_id = t.id
          WHERE tcr.performed_at::DATE BETWEEN date_from AND date_to
            AND (area_uuid IS NULL OR t.area_id = area_uuid)
        ),
        'activities_by_type', (
          SELECT jsonb_agg(
            jsonb_build_object(
              'activity_name', ca.name,
              'count', activity_data.count,
              'total_cost', activity_data.total_cost
            )
          )
          FROM (
            SELECT 
              tcr.care_activity_id,
              COUNT(*) as count,
              COALESCE(SUM(tcr.cost_amount), 0) as total_cost
            FROM tree_care_records tcr
            JOIN trees t ON tcr.tree_id = t.id
            WHERE tcr.performed_at::DATE BETWEEN date_from AND date_to
              AND (area_uuid IS NULL OR t.area_id = area_uuid)
            GROUP BY tcr.care_activity_id
          ) activity_data
          JOIN care_activities ca ON activity_data.care_activity_id = ca.id
        )
      );
      
    WHEN 'harvest_summary' THEN
      result := jsonb_build_object(
        'total_quantity', (
          SELECT COALESCE(SUM(hr.quantity), 0)
          FROM harvest_records hr
          JOIN trees t ON hr.tree_id = t.id
          WHERE hr.harvest_date BETWEEN date_from AND date_to
            AND (area_uuid IS NULL OR t.area_id = area_uuid)
        ),
        'total_value', (
          SELECT COALESCE(SUM(hr.total_value), 0)
          FROM harvest_records hr
          JOIN trees t ON hr.tree_id = t.id
          WHERE hr.harvest_date BETWEEN date_from AND date_to
            AND (area_uuid IS NULL OR t.area_id = area_uuid)
        ),
        'harvest_by_tree_type', (
          SELECT jsonb_agg(
            jsonb_build_object(
              'tree_type', tt.name,
              'quantity', harvest_data.quantity,
              'value', harvest_data.value
            )
          )
          FROM (
            SELECT 
              t.tree_type_id,
              SUM(hr.quantity) as quantity,
              SUM(hr.total_value) as value
            FROM harvest_records hr
            JOIN trees t ON hr.tree_id = t.id
            WHERE hr.harvest_date BETWEEN date_from AND date_to
              AND (area_uuid IS NULL OR t.area_id = area_uuid)
            GROUP BY t.tree_type_id
          ) harvest_data
          JOIN tree_types tt ON harvest_data.tree_type_id = tt.id
        )
      );
      
    ELSE
      result := jsonb_build_object('error', 'Unknown report type');
  END CASE;
  
  RETURN result;
END;
$$;


ALTER FUNCTION public.generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date) OWNER TO postgres;

--
-- Name: FUNCTION generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date) IS 'Generate data laporan dalam format JSON';


--
-- Name: generate_tree_barcode(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_tree_barcode() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  prefix TEXT := 'TRE';
  timestamp_part TEXT;
  random_part TEXT;
  barcode TEXT;
BEGIN
  -- Ambil timestamp dalam format YYYYMMDD
  timestamp_part := to_char(NOW(), 'YYYYMMDD');
  
  -- Generate random 4 digit number
  random_part := LPAD(floor(random() * 10000)::text, 4, '0');
  
  -- Gabungkan menjadi barcode: TRE-YYYYMMDD-XXXX
  barcode := prefix || '-' || timestamp_part || '-' || random_part;
  
  -- Pastikan barcode unik
  WHILE EXISTS (SELECT 1 FROM trees WHERE tree_code = barcode) LOOP
    random_part := LPAD(floor(random() * 10000)::text, 4, '0');
    barcode := prefix || '-' || timestamp_part || '-' || random_part;
  END LOOP;
  
  RETURN barcode;
END;
$$;


ALTER FUNCTION public.generate_tree_barcode() OWNER TO postgres;

--
-- Name: FUNCTION generate_tree_barcode(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.generate_tree_barcode() IS 'Generate barcode unik untuk pohon baru dengan format TRE-YYYYMMDD-XXXX';


--
-- Name: get_care_activity_summary(uuid, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_care_activity_summary(area_uuid uuid DEFAULT NULL::uuid, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS TABLE(activity_name text, activity_count bigint, total_cost numeric, average_duration integer, trees_affected bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Set default dates
  IF date_from IS NULL THEN
    date_from := CURRENT_DATE - INTERVAL '30 days';
  END IF;
  
  IF date_to IS NULL THEN
    date_to := CURRENT_DATE;
  END IF;
  
  RETURN QUERY
  SELECT 
    ca.name as activity_name,
    COUNT(*) as activity_count,
    COALESCE(SUM(tcr.cost_amount), 0) as total_cost,
    COALESCE(AVG(tcr.duration_minutes)::INTEGER, 0) as average_duration,
    COUNT(DISTINCT tcr.tree_id) as trees_affected
  FROM tree_care_records tcr
  JOIN care_activities ca ON tcr.care_activity_id = ca.id
  JOIN trees t ON tcr.tree_id = t.id
  WHERE tcr.performed_at::DATE BETWEEN date_from AND date_to
    AND (area_uuid IS NULL OR t.area_id = area_uuid)
  GROUP BY ca.id, ca.name
  ORDER BY activity_count DESC;
END;
$$;


ALTER FUNCTION public.get_care_activity_summary(area_uuid uuid, date_from date, date_to date) OWNER TO postgres;

--
-- Name: get_harvest_summary(uuid, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_harvest_summary(area_uuid uuid DEFAULT NULL::uuid, date_from date DEFAULT NULL::date, date_to date DEFAULT NULL::date) RETURNS TABLE(tree_type_name text, total_quantity numeric, total_value numeric, average_price numeric, harvest_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Set default dates
  IF date_from IS NULL THEN
    date_from := CURRENT_DATE - INTERVAL '30 days';
  END IF;
  
  IF date_to IS NULL THEN
    date_to := CURRENT_DATE;
  END IF;
  
  RETURN QUERY
  SELECT 
    tt.name as tree_type_name,
    SUM(hr.quantity) as total_quantity,
    SUM(hr.total_value) as total_value,
    AVG(hr.market_price_per_unit) as average_price,
    COUNT(*) as harvest_count
  FROM harvest_records hr
  JOIN trees t ON hr.tree_id = t.id
  JOIN tree_types tt ON t.tree_type_id = tt.id
  WHERE hr.harvest_date BETWEEN date_from AND date_to
    AND (area_uuid IS NULL OR t.area_id = area_uuid)
  GROUP BY tt.id, tt.name
  ORDER BY total_value DESC;
END;
$$;


ALTER FUNCTION public.get_harvest_summary(area_uuid uuid, date_from date, date_to date) OWNER TO postgres;

--
-- Name: get_overdue_care_activities(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_overdue_care_activities(area_uuid uuid DEFAULT NULL::uuid) RETURNS TABLE(tree_id uuid, tree_code text, care_activity_id uuid, care_activity_name text, due_date date, days_overdue integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    t.id as tree_id,
    t.tree_code,
    ca.id as care_activity_id,
    ca.name as care_activity_name,
    calculate_next_care_due_date(t.id, ca.id) as due_date,
    (CURRENT_DATE - calculate_next_care_due_date(t.id, ca.id))::INTEGER as days_overdue
  FROM trees t
  CROSS JOIN care_activities ca
  WHERE t.is_active = true
    AND ca.is_active = true
    AND ca.frequency_days IS NOT NULL
    AND (area_uuid IS NULL OR t.area_id = area_uuid)
    AND calculate_next_care_due_date(t.id, ca.id) < CURRENT_DATE
  ORDER BY days_overdue DESC;
END;
$$;


ALTER FUNCTION public.get_overdue_care_activities(area_uuid uuid) OWNER TO postgres;

--
-- Name: get_tree_productivity_rating(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  tree_age_months INTEGER;
  maturity_months INTEGER;
  total_harvest_value DECIMAL;
  avg_monthly_value DECIMAL;
  rating TEXT;
BEGIN
  -- Ambil data tree dan type
  SELECT 
    calculate_tree_age_months(t.planting_date),
    tt.maturity_period_months
  INTO tree_age_months, maturity_months
  FROM trees t
  JOIN tree_types tt ON t.tree_type_id = tt.id
  WHERE t.id = tree_uuid;
  
  -- Jika pohon belum matang
  IF tree_age_months < maturity_months THEN
    RETURN 'Belum Matang';
  END IF;
  
  -- Hitung total nilai harvest sejak matang
  SELECT COALESCE(SUM(total_value), 0) INTO total_harvest_value
  FROM harvest_records hr
  WHERE hr.tree_id = tree_uuid
    AND hr.harvest_date >= (
      SELECT planting_date + INTERVAL '1 month' * maturity_months
      FROM trees WHERE id = tree_uuid
    );
  
  -- Hitung rata-rata nilai per bulan sejak matang
  avg_monthly_value := total_harvest_value / GREATEST(tree_age_months - maturity_months, 1);
  
  -- Rating berdasarkan nilai rata-rata per bulan
  CASE
    WHEN avg_monthly_value >= 1000000 THEN rating := 'Sangat Produktif';
    WHEN avg_monthly_value >= 500000 THEN rating := 'Produktif';
    WHEN avg_monthly_value >= 100000 THEN rating := 'Cukup Produktif';
    WHEN avg_monthly_value > 0 THEN rating := 'Kurang Produktif';
    ELSE rating := 'Tidak Produktif';
  END CASE;
  
  RETURN rating;
END;
$$;


ALTER FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) OWNER TO postgres;

--
-- Name: FUNCTION get_tree_productivity_rating(tree_uuid uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) IS 'Evaluasi rating produktivitas pohon berdasarkan harvest dan umur';


--
-- Name: has_area_access(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_area_access(area_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Admin memiliki akses ke semua area
  IF public.is_admin() THEN
    RETURN TRUE;
  END IF;
  
  -- Leader Area hanya bisa akses area yang mereka kelola
  IF public.auth_user_role() = 'Leader Area' THEN
    RETURN area_uuid = ANY(public.user_managed_areas());
  END IF;
  
  -- Sales bisa akses semua area untuk read
  IF public.auth_user_role() = 'Sales' THEN
    RETURN TRUE;
  END IF;
  
  -- Pekerja bisa akses area tempat mereka assigned
  IF public.auth_user_role() = 'Pekerja' THEN
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
$$;


ALTER FUNCTION public.has_area_access(area_uuid uuid) OWNER TO postgres;

--
-- Name: FUNCTION has_area_access(area_uuid uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.has_area_access(area_uuid uuid) IS 'Mengecek apakah user memiliki akses ke area tertentu';


--
-- Name: has_permission(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.has_permission(permission_name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  user_permissions JSONB;
BEGIN
  SELECT ur.permissions INTO user_permissions
  FROM users u
  JOIN user_roles ur ON u.role_id = ur.id
  WHERE u.id = auth.uid();
  
  RETURN COALESCE((user_permissions->>permission_name)::BOOLEAN, FALSE);
END;
$$;


ALTER FUNCTION public.has_permission(permission_name text) OWNER TO postgres;

--
-- Name: FUNCTION has_permission(permission_name text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.has_permission(permission_name text) IS 'Mengecek permission spesifik dari role user';


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN public.auth_user_role() = 'Admin';
END;
$$;


ALTER FUNCTION public.is_admin() OWNER TO postgres;

--
-- Name: FUNCTION is_admin(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.is_admin() IS 'Mengecek apakah user saat ini adalah Admin';


--
-- Name: monthly_productivity_reports(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.monthly_productivity_reports() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  area_record RECORD;
  report_id UUID;
BEGIN
  -- Generate laporan produktivitas untuk setiap area
  FOR area_record IN 
    SELECT id, name, manager_id FROM areas WHERE is_active = true
  LOOP
    -- Generate report
    report_id := generate_automatic_report('monthly', area_record.id);
    
    -- Send notification ke manager area
    IF area_record.manager_id IS NOT NULL THEN
      INSERT INTO notifications (
        user_id, title, message, type, priority,
        related_entity_type, related_entity_id,
        scheduled_for, expires_at
      ) VALUES (
        area_record.manager_id, 
        'Laporan Produktivitas Bulanan Tersedia', 
        'Laporan produktivitas untuk area ' || area_record.name || ' bulan ini telah tersedia.',
        'report_ready', 'normal',
        'report', report_id,
        NOW(), NOW() + INTERVAL '30 days'
      );
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.monthly_productivity_reports() OWNER TO postgres;

--
-- Name: quarterly_cost_analysis(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.quarterly_cost_analysis() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  area_record RECORD;
  cost_summary JSONB;
  admin_users UUID[];
BEGIN
  -- Ambil semua admin users
  SELECT ARRAY_AGG(u.id) INTO admin_users
  FROM users u
  JOIN user_roles ur ON u.role_id = ur.id
  WHERE ur.name = 'Admin' AND u.is_active = true;
  
  -- Analisis biaya per area
  FOR area_record IN 
    SELECT id, name FROM areas WHERE is_active = true
  LOOP
    -- Hitung summary biaya 3 bulan terakhir
    SELECT jsonb_build_object(
      'total_operational_costs', COALESCE(SUM(oc.amount), 0),
      'total_care_costs', (
        SELECT COALESCE(SUM(tcr.cost_amount), 0)
        FROM tree_care_records tcr
        JOIN trees t ON tcr.tree_id = t.id
        WHERE t.area_id = area_record.id
          AND tcr.performed_at >= CURRENT_DATE - INTERVAL '3 months'
      ),
      'period', 'Q' || EXTRACT(QUARTER FROM CURRENT_DATE) || ' ' || EXTRACT(YEAR FROM CURRENT_DATE)
    ) INTO cost_summary
    FROM operational_costs oc
    WHERE oc.area_id = area_record.id
      AND oc.date >= CURRENT_DATE - INTERVAL '3 months'
      AND oc.status = 'paid';
    
    -- Create report
    INSERT INTO reports (
      title, type, category, description,
      generated_by, area_id, 
      date_from, date_to,
      data, status, is_scheduled
    ) VALUES (
      'Analisis Biaya Q' || EXTRACT(QUARTER FROM CURRENT_DATE) || ' - ' || area_record.name,
      'quarterly', 'cost_analysis',
      'Analisis biaya operasional dan perawatan per kuartal',
      admin_users[1], area_record.id,
      CURRENT_DATE - INTERVAL '3 months', CURRENT_DATE,
      cost_summary, 'completed', true
    );
  END LOOP;
END;
$$;


ALTER FUNCTION public.quarterly_cost_analysis() OWNER TO postgres;

--
-- Name: tree_needs_care(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.tree_needs_care(tree_uuid uuid, care_activity_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  next_due_date DATE;
BEGIN
  next_due_date := calculate_next_care_due_date(tree_uuid, care_activity_uuid);
  
  IF next_due_date IS NULL THEN
    RETURN false;
  END IF;
  
  RETURN next_due_date <= CURRENT_DATE;
END;
$$;


ALTER FUNCTION public.tree_needs_care(tree_uuid uuid, care_activity_uuid uuid) OWNER TO postgres;

--
-- Name: update_tree_status_from_care(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_tree_status_from_care() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  tree_record trees%ROWTYPE;
  last_care_date DATE;
  days_since_care INTEGER;
BEGIN
  -- Ambil data pohon
  SELECT * INTO tree_record FROM trees WHERE id = NEW.tree_id;
  
  -- Update health status berdasarkan after_condition
  IF NEW.after_condition IS NOT NULL THEN
    CASE
      WHEN NEW.after_condition ILIKE '%mati%' OR NEW.after_condition ILIKE '%dead%' THEN
        UPDATE trees SET health_status = 'dead' WHERE id = NEW.tree_id;
      WHEN NEW.after_condition ILIKE '%sakit%' OR NEW.after_condition ILIKE '%sick%' THEN
        UPDATE trees SET health_status = 'sick' WHERE id = NEW.tree_id;
      WHEN NEW.after_condition ILIKE '%kritis%' OR NEW.after_condition ILIKE '%critical%' THEN
        UPDATE trees SET health_status = 'critical' WHERE id = NEW.tree_id;
      WHEN NEW.after_condition ILIKE '%sehat%' OR NEW.after_condition ILIKE '%healthy%' THEN
        UPDATE trees SET health_status = 'healthy' WHERE id = NEW.tree_id;
    END CASE;
  END IF;
  
  -- Update growth stage berdasarkan umur
  UPDATE trees 
  SET growth_stage = CASE
    WHEN calculate_tree_age_months(planting_date) < 6 THEN 'seedling'
    WHEN calculate_tree_age_months(planting_date) < 24 THEN 'young'
    WHEN calculate_tree_age_months(planting_date) < 60 THEN 'mature'
    ELSE 'old'
  END
  WHERE id = NEW.tree_id;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_tree_status_from_care() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

--
-- Name: FUNCTION update_updated_at_column(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.update_updated_at_column() IS 'Function trigger untuk update timestamp updated_at';


--
-- Name: user_managed_areas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_managed_areas() RETURNS uuid[]
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  managed_areas UUID[];
BEGIN
  -- Untuk Leader Area, ambil area yang mereka kelola
  IF public.auth_user_role() = 'Leader Area' THEN
    SELECT ARRAY_AGG(a.id) INTO managed_areas
    FROM areas a
    WHERE a.manager_id = auth.uid();
    
    RETURN COALESCE(managed_areas, ARRAY[]::UUID[]);
  END IF;
  
  -- Untuk role lain, return empty array
  RETURN ARRAY[]::UUID[];
END;
$$;


ALTER FUNCTION public.user_managed_areas() OWNER TO postgres;

--
-- Name: FUNCTION user_managed_areas(); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.user_managed_areas() IS 'Mengambil daftar area_id yang dikelola oleh Leader Area';


--
-- Name: validate_coordinates(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_coordinates(coordinates jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  lat DECIMAL;
  lng DECIMAL;
BEGIN
  -- Check if coordinates is valid JSON with lat and lng
  IF coordinates IS NULL THEN
    RETURN true; -- Allow null coordinates
  END IF;
  
  -- Extract latitude and longitude
  BEGIN
    lat := (coordinates->>'lat')::DECIMAL;
    lng := (coordinates->>'lng')::DECIMAL;
  EXCEPTION WHEN OTHERS THEN
    RETURN false;
  END;
  
  -- Validate latitude range (-90 to 90)
  IF lat < -90 OR lat > 90 THEN
    RETURN false;
  END IF;
  
  -- Validate longitude range (-180 to 180)
  IF lng < -180 OR lng > 180 THEN
    RETURN false;
  END IF;
  
  RETURN true;
END;
$$;


ALTER FUNCTION public.validate_coordinates(coordinates jsonb) OWNER TO postgres;

--
-- Name: FUNCTION validate_coordinates(coordinates jsonb); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.validate_coordinates(coordinates jsonb) IS 'Validasi format dan range koordinat GPS';


--
-- Name: validate_harvest_quantity(uuid, numeric, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  tree_age_months INTEGER;
  maturity_months INTEGER;
  max_expected_quantity DECIMAL;
BEGIN
  -- Ambil data pohon
  SELECT 
    calculate_tree_age_months(harvest_date),
    tt.maturity_period_months
  INTO tree_age_months, maturity_months
  FROM trees t
  JOIN tree_types tt ON t.tree_type_id = tt.id
  WHERE t.id = tree_uuid;
  
  -- Pohon harus sudah matang untuk bisa dipanen
  IF tree_age_months < maturity_months THEN
    RETURN false;
  END IF;
  
  -- Quantity harus positif
  IF quantity <= 0 THEN
    RETURN false;
  END IF;
  
  -- Check apakah quantity realistis (tidak terlalu besar)
  -- Asumsi: maksimal 1000 kg per pohon per panen
  max_expected_quantity := 1000;
  
  IF quantity > max_expected_quantity THEN
    RETURN false;
  END IF;
  
  RETURN true;
END;
$$;


ALTER FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) OWNER TO postgres;

--
-- Name: FUNCTION validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) IS 'Validasi quantity harvest sesuai umur dan jenis pohon';


--
-- Name: validate_planting_date(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_planting_date(planting_date date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Planting date tidak boleh di masa depan
  IF planting_date > CURRENT_DATE THEN
    RETURN false;
  END IF;
  
  -- Planting date tidak boleh terlalu lama (misal 50 tahun yang lalu)
  IF planting_date < CURRENT_DATE - INTERVAL '50 years' THEN
    RETURN false;
  END IF;
  
  RETURN true;
END;
$$;


ALTER FUNCTION public.validate_planting_date(planting_date date) OWNER TO postgres;

--
-- Name: FUNCTION validate_planting_date(planting_date date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.validate_planting_date(planting_date date) IS 'Validasi tanggal tanam tidak di masa depan atau terlalu lama';


--
-- Name: weekly_care_due_notifications(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.weekly_care_due_notifications() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  tree_record RECORD;
  notification_message TEXT;
  manager_id UUID;
BEGIN
  -- Loop through trees yang memerlukan perawatan dalam 7 hari ke depan
  FOR tree_record IN 
    SELECT DISTINCT
      t.id,
      t.tree_code,
      t.area_id,
      ca.name as care_activity_name,
      calculate_next_care_due_date(t.id, ca.id) as next_due_date
    FROM trees t
    CROSS JOIN care_activities ca
    WHERE t.is_active = true 
      AND ca.is_active = true
      AND ca.frequency_days IS NOT NULL
      AND calculate_next_care_due_date(t.id, ca.id) BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
  LOOP
    -- Ambil manager area
    SELECT a.manager_id INTO manager_id
    FROM areas a WHERE a.id = tree_record.area_id;
    
    IF manager_id IS NOT NULL THEN
      notification_message := 'Pohon ' || tree_record.tree_code || 
        ' memerlukan perawatan ' || tree_record.care_activity_name || 
        ' pada tanggal ' || to_char(tree_record.next_due_date, 'DD/MM/YYYY');
        
      -- Create notification
      INSERT INTO notifications (
        user_id, title, message, type, priority,
        related_entity_type, related_entity_id,
        scheduled_for, expires_at
      ) VALUES (
        manager_id, 'Perawatan Pohon Akan Jatuh Tempo', notification_message, 
        'care_reminder', 'normal',
        'tree', tree_record.id,
        NOW(), NOW() + INTERVAL '14 days'
      );
    END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.weekly_care_due_notifications() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    location text,
    coordinates jsonb,
    total_area numeric(10,2),
    soil_type character varying(50),
    climate_zone character varying(50),
    manager_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_area_total_area_positive CHECK (((total_area IS NULL) OR (total_area > (0)::numeric)))
);


ALTER TABLE public.areas OWNER TO postgres;

--
-- Name: TABLE areas; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.areas IS 'Area atau lahan tempat pohon-pohon ditanam dan dikelola';


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid,
    action character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id uuid,
    old_values jsonb,
    new_values jsonb,
    changed_fields text[],
    ip_address inet,
    user_agent text,
    session_id character varying(255),
    request_id character varying(255),
    additional_info jsonb,
    severity character varying(10) DEFAULT 'info'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT audit_logs_severity_check CHECK (((severity)::text = ANY ((ARRAY['info'::character varying, 'warning'::character varying, 'error'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: TABLE audit_logs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.audit_logs IS 'Log audit untuk melacak semua perubahan data dan aktivitas user';


--
-- Name: care_activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.care_activities (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    category character varying(50),
    frequency_days integer,
    estimated_duration_minutes integer,
    required_tools text,
    instructions text,
    safety_notes text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_care_category CHECK (((category IS NULL) OR ((category)::text = ANY ((ARRAY['Penyiraman'::character varying, 'Pemupukan'::character varying, 'Pemangkasan'::character varying, 'Penyiangan'::character varying, 'Pengendalian Hama'::character varying, 'Monitoring'::character varying, 'Lainnya'::character varying])::text[])))),
    CONSTRAINT chk_care_duration_positive CHECK (((estimated_duration_minutes IS NULL) OR (estimated_duration_minutes > 0))),
    CONSTRAINT chk_care_frequency_positive CHECK (((frequency_days IS NULL) OR (frequency_days > 0)))
);


ALTER TABLE public.care_activities OWNER TO postgres;

--
-- Name: TABLE care_activities; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.care_activities IS 'Master data jenis-jenis aktivitas perawatan pohon';


--
-- Name: harvest_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.harvest_records (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tree_id uuid NOT NULL,
    harvested_by uuid NOT NULL,
    harvest_date date NOT NULL,
    quantity numeric(10,2) NOT NULL,
    unit character varying(20) NOT NULL,
    quality_grade character varying(20),
    market_price_per_unit numeric(12,2),
    total_value numeric(15,2),
    storage_location text,
    buyer_info text,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_harvest_date_valid CHECK ((harvest_date <= CURRENT_DATE)),
    CONSTRAINT chk_harvest_price_positive CHECK (((market_price_per_unit IS NULL) OR (market_price_per_unit >= (0)::numeric))),
    CONSTRAINT chk_harvest_quality_grade CHECK (((quality_grade IS NULL) OR ((quality_grade)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Premium'::character varying, 'Standard'::character varying, 'Low'::character varying])::text[])))),
    CONSTRAINT chk_harvest_quantity_positive CHECK ((quantity > (0)::numeric)),
    CONSTRAINT chk_harvest_value_positive CHECK (((total_value IS NULL) OR (total_value >= (0)::numeric)))
);


ALTER TABLE public.harvest_records OWNER TO postgres;

--
-- Name: TABLE harvest_records; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.harvest_records IS 'Catatan hasil panen dari pohon-pohon produktif';


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    title character varying(200) NOT NULL,
    message text NOT NULL,
    type character varying(50) NOT NULL,
    priority character varying(10) DEFAULT 'normal'::character varying,
    related_entity_type character varying(50),
    related_entity_id uuid,
    is_read boolean DEFAULT false,
    read_at timestamp with time zone,
    action_required boolean DEFAULT false,
    action_url text,
    scheduled_for timestamp with time zone,
    sent_at timestamp with time zone,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_notification_dates CHECK (((expires_at IS NULL) OR (expires_at > created_at))),
    CONSTRAINT chk_notification_entity_type CHECK (((related_entity_type IS NULL) OR ((related_entity_type)::text = ANY ((ARRAY['tree'::character varying, 'area'::character varying, 'care_record'::character varying, 'harvest_record'::character varying, 'report'::character varying, 'user'::character varying])::text[])))),
    CONSTRAINT chk_notification_type CHECK (((type)::text = ANY ((ARRAY['care_reminder'::character varying, 'harvest_time'::character varying, 'maintenance_due'::character varying, 'alert'::character varying, 'system'::character varying, 'report_ready'::character varying])::text[]))),
    CONSTRAINT notifications_priority_check CHECK (((priority)::text = ANY ((ARRAY['low'::character varying, 'normal'::character varying, 'high'::character varying, 'urgent'::character varying])::text[])))
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: TABLE notifications; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.notifications IS 'Sistem notifikasi untuk mengingatkan aktivitas dan jadwal';


--
-- Name: operational_costs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.operational_costs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    category character varying(50) NOT NULL,
    subcategory character varying(100),
    description text NOT NULL,
    amount numeric(15,2) NOT NULL,
    currency character varying(3) DEFAULT 'IDR'::character varying,
    date date NOT NULL,
    area_id uuid,
    tree_id uuid,
    vendor_name character varying(100),
    invoice_number character varying(100),
    payment_method character varying(50),
    paid_by uuid,
    approved_by uuid,
    receipt_url text,
    is_recurring boolean DEFAULT false,
    recurrence_pattern character varying(50),
    status character varying(20) DEFAULT 'pending'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    additional_info jsonb,
    CONSTRAINT chk_operational_amount_positive CHECK ((amount > (0)::numeric)),
    CONSTRAINT chk_operational_currency CHECK (((currency)::text = ANY ((ARRAY['IDR'::character varying, 'USD'::character varying, 'EUR'::character varying])::text[]))),
    CONSTRAINT chk_operational_date_valid CHECK ((date <= CURRENT_DATE)),
    CONSTRAINT operational_costs_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'paid'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.operational_costs OWNER TO postgres;

--
-- Name: TABLE operational_costs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.operational_costs IS 'Catatan biaya operasional untuk manajemen pohon dan area';


--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    filename character varying(255) NOT NULL,
    original_filename character varying(255),
    file_path text NOT NULL,
    file_url text NOT NULL,
    file_size_bytes bigint,
    mime_type character varying(100),
    width_px integer,
    height_px integer,
    uploaded_by uuid NOT NULL,
    related_entity_type character varying(50) NOT NULL,
    related_entity_id uuid NOT NULL,
    photo_type character varying(50),
    caption text,
    taken_at timestamp with time zone,
    coordinates jsonb,
    weather_condition character varying(50),
    tags text[],
    is_primary boolean DEFAULT false,
    is_public boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_photo_dimensions_positive CHECK ((((width_px IS NULL) OR (width_px > 0)) AND ((height_px IS NULL) OR (height_px > 0)))),
    CONSTRAINT chk_photo_entity_type CHECK (((related_entity_type)::text = ANY ((ARRAY['tree'::character varying, 'area'::character varying, 'care_record'::character varying, 'harvest_record'::character varying, 'user'::character varying, 'report'::character varying])::text[]))),
    CONSTRAINT chk_photo_file_size_positive CHECK (((file_size_bytes IS NULL) OR (file_size_bytes > 0))),
    CONSTRAINT chk_photo_type CHECK (((photo_type IS NULL) OR ((photo_type)::text = ANY ((ARRAY['before'::character varying, 'after'::character varying, 'progress'::character varying, 'condition'::character varying, 'documentation'::character varying, 'profile'::character varying])::text[]))))
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- Name: TABLE photos; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.photos IS 'Dokumentasi foto pohon, kondisi, dan aktivitas perawatan';


--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    title character varying(200) NOT NULL,
    type character varying(50) NOT NULL,
    category character varying(50),
    description text,
    generated_by uuid NOT NULL,
    area_id uuid,
    date_from date NOT NULL,
    date_to date NOT NULL,
    parameters jsonb,
    data jsonb,
    summary_stats jsonb,
    file_url text,
    file_format character varying(10),
    status character varying(20) DEFAULT 'generating'::character varying,
    is_scheduled boolean DEFAULT false,
    schedule_pattern character varying(50),
    next_generation_date date,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_report_category CHECK (((category IS NULL) OR ((category)::text = ANY ((ARRAY['care_summary'::character varying, 'harvest_report'::character varying, 'cost_analysis'::character varying, 'performance'::character varying, 'maintenance'::character varying, 'overview'::character varying])::text[])))),
    CONSTRAINT chk_report_date_range CHECK ((date_to >= date_from)),
    CONSTRAINT chk_report_format CHECK (((file_format IS NULL) OR ((file_format)::text = ANY ((ARRAY['pdf'::character varying, 'xlsx'::character varying, 'csv'::character varying, 'json'::character varying])::text[])))),
    CONSTRAINT chk_report_type CHECK (((type)::text = ANY ((ARRAY['daily'::character varying, 'weekly'::character varying, 'monthly'::character varying, 'quarterly'::character varying, 'annual'::character varying, 'custom'::character varying])::text[]))),
    CONSTRAINT reports_status_check CHECK (((status)::text = ANY ((ARRAY['generating'::character varying, 'completed'::character varying, 'failed'::character varying])::text[])))
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: TABLE reports; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.reports IS 'Laporan yang dihasilkan sistem untuk analisis dan monitoring';


--
-- Name: tree_care_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tree_care_records (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tree_id uuid NOT NULL,
    care_activity_id uuid NOT NULL,
    performed_by uuid NOT NULL,
    performed_at timestamp with time zone NOT NULL,
    duration_minutes integer,
    notes text,
    before_condition text,
    after_condition text,
    materials_used jsonb,
    cost_amount numeric(12,2),
    weather_condition character varying(50),
    is_scheduled boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_care_cost_positive CHECK (((cost_amount IS NULL) OR (cost_amount >= (0)::numeric))),
    CONSTRAINT chk_care_duration_positive CHECK (((duration_minutes IS NULL) OR (duration_minutes > 0))),
    CONSTRAINT chk_care_performed_date CHECK ((performed_at <= now()))
);


ALTER TABLE public.tree_care_records OWNER TO postgres;

--
-- Name: TABLE tree_care_records; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tree_care_records IS 'Catatan historis perawatan yang dilakukan pada setiap pohon';


--
-- Name: tree_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tree_types (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    scientific_name character varying(150),
    local_name character varying(100),
    category character varying(50),
    description text,
    planting_season character varying(50),
    harvest_season character varying(50),
    maturity_period_months integer,
    average_height_meters numeric(5,2),
    care_instructions text,
    climate_requirements text,
    soil_requirements text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_tree_type_category CHECK (((category IS NULL) OR ((category)::text = ANY ((ARRAY['Buah'::character varying, 'Kayu'::character varying, 'Hias'::character varying, 'Obat'::character varying, 'Rempah'::character varying, 'Sayuran'::character varying, 'Lainnya'::character varying])::text[])))),
    CONSTRAINT chk_tree_type_height_positive CHECK (((average_height_meters IS NULL) OR (average_height_meters > (0)::numeric))),
    CONSTRAINT chk_tree_type_maturity_positive CHECK (((maturity_period_months IS NULL) OR (maturity_period_months > 0)))
);


ALTER TABLE public.tree_types OWNER TO postgres;

--
-- Name: TABLE tree_types; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.tree_types IS 'Master data jenis-jenis pohon yang dapat ditanam';


--
-- Name: trees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trees (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    tree_code character varying(50) NOT NULL,
    tree_type_id uuid NOT NULL,
    area_id uuid NOT NULL,
    planted_by uuid,
    planting_date date NOT NULL,
    coordinates jsonb,
    current_height_cm numeric(6,2),
    current_diameter_cm numeric(6,2),
    health_status character varying(20) DEFAULT 'healthy'::character varying,
    growth_stage character varying(20) DEFAULT 'seedling'::character varying,
    notes text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_tree_diameter_positive CHECK (((current_diameter_cm IS NULL) OR (current_diameter_cm > (0)::numeric))),
    CONSTRAINT chk_tree_height_positive CHECK (((current_height_cm IS NULL) OR (current_height_cm > (0)::numeric))),
    CONSTRAINT trees_growth_stage_check CHECK (((growth_stage)::text = ANY ((ARRAY['seedling'::character varying, 'young'::character varying, 'mature'::character varying, 'old'::character varying])::text[]))),
    CONSTRAINT trees_health_status_check CHECK (((health_status)::text = ANY ((ARRAY['healthy'::character varying, 'sick'::character varying, 'dead'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.trees OWNER TO postgres;

--
-- Name: TABLE trees; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.trees IS 'Data individual setiap pohon yang ditanam di area';


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    permissions jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: TABLE user_roles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.user_roles IS 'Menyimpan jenis-jenis peran pengguna dalam sistem manajemen pohon';


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(100) NOT NULL,
    phone character varying(20),
    avatar_url text,
    role_id uuid,
    employee_id character varying(50),
    department character varying(100),
    hire_date date,
    is_active boolean DEFAULT true,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Data pengguna yang extends dari Supabase Auth dengan informasi karyawan';


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: areas areas_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_code_key UNIQUE (code);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: care_activities care_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.care_activities
    ADD CONSTRAINT care_activities_pkey PRIMARY KEY (id);


--
-- Name: harvest_records harvest_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest_records
    ADD CONSTRAINT harvest_records_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: operational_costs operational_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT operational_costs_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: tree_care_records tree_care_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT tree_care_records_pkey PRIMARY KEY (id);


--
-- Name: tree_types tree_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_types
    ADD CONSTRAINT tree_types_pkey PRIMARY KEY (id);


--
-- Name: trees trees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT trees_pkey PRIMARY KEY (id);


--
-- Name: trees trees_tree_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT trees_tree_code_key UNIQUE (tree_code);


--
-- Name: user_roles user_roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_name_key UNIQUE (name);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_areas_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_active_only ON public.areas USING btree (id) WHERE (is_active = true);


--
-- Name: idx_areas_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_code ON public.areas USING btree (code);


--
-- Name: idx_areas_coordinates_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_coordinates_gin ON public.areas USING gin (coordinates);


--
-- Name: idx_areas_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_is_active ON public.areas USING btree (is_active);


--
-- Name: idx_areas_manager_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_areas_manager_id ON public.areas USING btree (manager_id);


--
-- Name: idx_audit_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_action ON public.audit_logs USING btree (action);


--
-- Name: idx_audit_logs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_created_at ON public.audit_logs USING btree (created_at);


--
-- Name: idx_audit_logs_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_entity ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: idx_audit_logs_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_entity_id ON public.audit_logs USING btree (entity_id);


--
-- Name: idx_audit_logs_entity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_entity_type ON public.audit_logs USING btree (entity_type);


--
-- Name: idx_audit_logs_new_values_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_new_values_gin ON public.audit_logs USING gin (new_values);


--
-- Name: idx_audit_logs_old_values_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_old_values_gin ON public.audit_logs USING gin (old_values);


--
-- Name: idx_audit_logs_severity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_severity ON public.audit_logs USING btree (severity);


--
-- Name: idx_audit_logs_user_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_user_action ON public.audit_logs USING btree (user_id, action);


--
-- Name: idx_audit_logs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_user_id ON public.audit_logs USING btree (user_id);


--
-- Name: idx_care_activities_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_activities_active_only ON public.care_activities USING btree (id) WHERE (is_active = true);


--
-- Name: idx_care_activities_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_activities_category ON public.care_activities USING btree (category);


--
-- Name: idx_care_activities_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_activities_is_active ON public.care_activities USING btree (is_active);


--
-- Name: idx_care_records_activity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_activity_id ON public.tree_care_records USING btree (care_activity_id);


--
-- Name: idx_care_records_is_scheduled; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_is_scheduled ON public.tree_care_records USING btree (is_scheduled);


--
-- Name: idx_care_records_materials_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_materials_gin ON public.tree_care_records USING gin (materials_used);


--
-- Name: idx_care_records_performed_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_performed_at ON public.tree_care_records USING btree (performed_at);


--
-- Name: idx_care_records_performed_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_performed_by ON public.tree_care_records USING btree (performed_by);


--
-- Name: idx_care_records_tree_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_tree_date ON public.tree_care_records USING btree (tree_id, performed_at);


--
-- Name: idx_care_records_tree_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_tree_id ON public.tree_care_records USING btree (tree_id);


--
-- Name: idx_care_records_user_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_care_records_user_date ON public.tree_care_records USING btree (performed_by, performed_at);


--
-- Name: idx_harvest_records_date_quality; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_date_quality ON public.harvest_records USING btree (harvest_date, quality_grade);


--
-- Name: idx_harvest_records_harvest_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_harvest_date ON public.harvest_records USING btree (harvest_date);


--
-- Name: idx_harvest_records_harvested_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_harvested_by ON public.harvest_records USING btree (harvested_by);


--
-- Name: idx_harvest_records_quality_grade; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_quality_grade ON public.harvest_records USING btree (quality_grade);


--
-- Name: idx_harvest_records_tree_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_tree_date ON public.harvest_records USING btree (tree_id, harvest_date);


--
-- Name: idx_harvest_records_tree_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_harvest_records_tree_id ON public.harvest_records USING btree (tree_id);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at);


--
-- Name: idx_notifications_high_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_high_priority ON public.notifications USING btree (user_id, created_at) WHERE ((priority)::text = ANY ((ARRAY['high'::character varying, 'urgent'::character varying])::text[]));


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_priority ON public.notifications USING btree (priority);


--
-- Name: idx_notifications_priority_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_priority_read ON public.notifications USING btree (priority, is_read);


--
-- Name: idx_notifications_scheduled_for; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_scheduled_for ON public.notifications USING btree (scheduled_for);


--
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- Name: idx_notifications_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_unread ON public.notifications USING btree (user_id, created_at) WHERE (is_read = false);


--
-- Name: idx_notifications_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);


--
-- Name: idx_notifications_user_read; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_read ON public.notifications USING btree (user_id, is_read);


--
-- Name: idx_notifications_user_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user_type ON public.notifications USING btree (user_id, type);


--
-- Name: idx_operational_costs_additional_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_additional_gin ON public.operational_costs USING gin (additional_info) WHERE (additional_info IS NOT NULL);


--
-- Name: idx_operational_costs_area_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_area_date ON public.operational_costs USING btree (area_id, date);


--
-- Name: idx_operational_costs_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_area_id ON public.operational_costs USING btree (area_id);


--
-- Name: idx_operational_costs_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_category ON public.operational_costs USING btree (category);


--
-- Name: idx_operational_costs_category_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_category_date ON public.operational_costs USING btree (category, date);


--
-- Name: idx_operational_costs_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_date ON public.operational_costs USING btree (date);


--
-- Name: idx_operational_costs_paid_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_paid_by ON public.operational_costs USING btree (paid_by);


--
-- Name: idx_operational_costs_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_status ON public.operational_costs USING btree (status);


--
-- Name: idx_operational_costs_tree_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_operational_costs_tree_id ON public.operational_costs USING btree (tree_id);


--
-- Name: idx_photos_coordinates_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_coordinates_gin ON public.photos USING gin (coordinates);


--
-- Name: idx_photos_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_entity ON public.photos USING btree (related_entity_type, related_entity_id);


--
-- Name: idx_photos_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_entity_id ON public.photos USING btree (related_entity_id);


--
-- Name: idx_photos_entity_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_entity_primary ON public.photos USING btree (related_entity_type, related_entity_id, is_primary);


--
-- Name: idx_photos_entity_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_entity_type ON public.photos USING btree (related_entity_type);


--
-- Name: idx_photos_is_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_is_primary ON public.photos USING btree (is_primary);


--
-- Name: idx_photos_photo_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_photo_type ON public.photos USING btree (photo_type);


--
-- Name: idx_photos_primary_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_primary_only ON public.photos USING btree (related_entity_type, related_entity_id) WHERE (is_primary = true);


--
-- Name: idx_photos_taken_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_taken_at ON public.photos USING btree (taken_at);


--
-- Name: idx_photos_uploaded_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_uploaded_by ON public.photos USING btree (uploaded_by);


--
-- Name: idx_reports_area_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_area_date ON public.reports USING btree (area_id, date_from, date_to);


--
-- Name: idx_reports_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_area_id ON public.reports USING btree (area_id);


--
-- Name: idx_reports_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_category ON public.reports USING btree (category);


--
-- Name: idx_reports_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_created_at ON public.reports USING btree (created_at);


--
-- Name: idx_reports_data_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_data_gin ON public.reports USING gin (data);


--
-- Name: idx_reports_generated_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_generated_by ON public.reports USING btree (generated_by);


--
-- Name: idx_reports_parameters_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_parameters_gin ON public.reports USING gin (parameters);


--
-- Name: idx_reports_pending; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_pending ON public.reports USING btree (created_at) WHERE ((status)::text = ANY ((ARRAY['generating'::character varying, 'pending'::character varying])::text[]));


--
-- Name: idx_reports_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_status ON public.reports USING btree (status);


--
-- Name: idx_reports_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_type ON public.reports USING btree (type);


--
-- Name: idx_reports_type_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_type_status ON public.reports USING btree (type, status);


--
-- Name: idx_tree_types_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tree_types_active_only ON public.tree_types USING btree (id) WHERE (is_active = true);


--
-- Name: idx_tree_types_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tree_types_category ON public.tree_types USING btree (category);


--
-- Name: idx_tree_types_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tree_types_is_active ON public.tree_types USING btree (is_active);


--
-- Name: idx_trees_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_active_only ON public.trees USING btree (id) WHERE (is_active = true);


--
-- Name: idx_trees_area_health; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_area_health ON public.trees USING btree (area_id, health_status);


--
-- Name: idx_trees_area_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_area_id ON public.trees USING btree (area_id);


--
-- Name: idx_trees_area_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_area_type ON public.trees USING btree (area_id, tree_type_id);


--
-- Name: idx_trees_coordinates_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_coordinates_gin ON public.trees USING gin (coordinates);


--
-- Name: idx_trees_growth_stage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_growth_stage ON public.trees USING btree (growth_stage);


--
-- Name: idx_trees_health_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_health_status ON public.trees USING btree (health_status);


--
-- Name: idx_trees_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_is_active ON public.trees USING btree (is_active);


--
-- Name: idx_trees_planted_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_planted_by ON public.trees USING btree (planted_by);


--
-- Name: idx_trees_planting_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_planting_date ON public.trees USING btree (planting_date);


--
-- Name: idx_trees_status_stage; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_status_stage ON public.trees USING btree (health_status, growth_stage);


--
-- Name: idx_trees_tree_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_tree_code ON public.trees USING btree (tree_code);


--
-- Name: idx_trees_tree_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_trees_tree_type_id ON public.trees USING btree (tree_type_id);


--
-- Name: idx_user_roles_permissions_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_permissions_gin ON public.user_roles USING gin (permissions);


--
-- Name: idx_users_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_active_only ON public.users USING btree (id) WHERE (is_active = true);


--
-- Name: idx_users_employee_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_employee_id ON public.users USING btree (employee_id);


--
-- Name: idx_users_is_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_is_active ON public.users USING btree (is_active);


--
-- Name: idx_users_last_login; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_last_login ON public.users USING btree (last_login_at);


--
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: areas audit_areas; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_areas AFTER INSERT OR DELETE OR UPDATE ON public.areas FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: harvest_records audit_harvest_records; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_harvest_records AFTER INSERT OR DELETE OR UPDATE ON public.harvest_records FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: operational_costs audit_operational_costs; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_operational_costs AFTER INSERT OR DELETE OR UPDATE ON public.operational_costs FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: tree_care_records audit_tree_care_records; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_tree_care_records AFTER INSERT OR DELETE OR UPDATE ON public.tree_care_records FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: trees audit_trees; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_trees AFTER INSERT OR DELETE OR UPDATE ON public.trees FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: users audit_users; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER audit_users AFTER INSERT OR DELETE OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();


--
-- Name: trees auto_generate_tree_barcode_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_generate_tree_barcode_trigger BEFORE INSERT ON public.trees FOR EACH ROW EXECUTE FUNCTION public.auto_generate_tree_barcode();


--
-- Name: notifications cleanup_notifications; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cleanup_notifications AFTER INSERT ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.cleanup_expired_notifications_trigger();


--
-- Name: tree_care_records create_care_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER create_care_notification AFTER INSERT ON public.tree_care_records FOR EACH ROW EXECUTE FUNCTION public.create_automatic_notification();


--
-- Name: harvest_records create_harvest_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER create_harvest_notification AFTER INSERT ON public.harvest_records FOR EACH ROW EXECUTE FUNCTION public.create_automatic_notification();


--
-- Name: trees create_tree_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER create_tree_notification AFTER UPDATE ON public.trees FOR EACH ROW EXECUTE FUNCTION public.create_automatic_notification();


--
-- Name: areas update_areas_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_areas_updated_at BEFORE UPDATE ON public.areas FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: care_activities update_care_activities_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_care_activities_updated_at BEFORE UPDATE ON public.care_activities FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: harvest_records update_harvest_records_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_harvest_records_updated_at BEFORE UPDATE ON public.harvest_records FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: notifications update_notifications_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: operational_costs update_operational_costs_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_operational_costs_updated_at BEFORE UPDATE ON public.operational_costs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: photos update_photos_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_photos_updated_at BEFORE UPDATE ON public.photos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: reports update_reports_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_reports_updated_at BEFORE UPDATE ON public.reports FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tree_care_records update_tree_care_records_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_tree_care_records_updated_at BEFORE UPDATE ON public.tree_care_records FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tree_care_records update_tree_status_after_care; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_tree_status_after_care AFTER INSERT OR UPDATE ON public.tree_care_records FOR EACH ROW EXECUTE FUNCTION public.update_tree_status_from_care();


--
-- Name: tree_types update_tree_types_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_tree_types_updated_at BEFORE UPDATE ON public.tree_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: trees update_trees_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_trees_updated_at BEFORE UPDATE ON public.trees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: user_roles update_user_roles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_roles_updated_at BEFORE UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: areas areas_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.users(id);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: areas fk_areas_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT fk_areas_manager FOREIGN KEY (manager_id) REFERENCES public.users(id);


--
-- Name: audit_logs fk_audit_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tree_care_records fk_care_records_activity; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT fk_care_records_activity FOREIGN KEY (care_activity_id) REFERENCES public.care_activities(id);


--
-- Name: tree_care_records fk_care_records_performed_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT fk_care_records_performed_by FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: tree_care_records fk_care_records_tree; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT fk_care_records_tree FOREIGN KEY (tree_id) REFERENCES public.trees(id) ON DELETE CASCADE;


--
-- Name: harvest_records fk_harvest_records_harvested_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest_records
    ADD CONSTRAINT fk_harvest_records_harvested_by FOREIGN KEY (harvested_by) REFERENCES public.users(id);


--
-- Name: harvest_records fk_harvest_records_tree; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest_records
    ADD CONSTRAINT fk_harvest_records_tree FOREIGN KEY (tree_id) REFERENCES public.trees(id) ON DELETE CASCADE;


--
-- Name: notifications fk_notifications_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: operational_costs fk_operational_costs_approved_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT fk_operational_costs_approved_by FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: operational_costs fk_operational_costs_area; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT fk_operational_costs_area FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: operational_costs fk_operational_costs_paid_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT fk_operational_costs_paid_by FOREIGN KEY (paid_by) REFERENCES public.users(id);


--
-- Name: operational_costs fk_operational_costs_tree; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT fk_operational_costs_tree FOREIGN KEY (tree_id) REFERENCES public.trees(id);


--
-- Name: photos fk_photos_uploaded_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT fk_photos_uploaded_by FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: reports fk_reports_area; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_area FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: reports fk_reports_generated_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_generated_by FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: trees fk_trees_area; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT fk_trees_area FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: trees fk_trees_planted_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT fk_trees_planted_by FOREIGN KEY (planted_by) REFERENCES public.users(id);


--
-- Name: trees fk_trees_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT fk_trees_type FOREIGN KEY (tree_type_id) REFERENCES public.tree_types(id);


--
-- Name: users fk_users_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES public.user_roles(id);


--
-- Name: harvest_records harvest_records_harvested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest_records
    ADD CONSTRAINT harvest_records_harvested_by_fkey FOREIGN KEY (harvested_by) REFERENCES public.users(id);


--
-- Name: harvest_records harvest_records_tree_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harvest_records
    ADD CONSTRAINT harvest_records_tree_id_fkey FOREIGN KEY (tree_id) REFERENCES public.trees(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: operational_costs operational_costs_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT operational_costs_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: operational_costs operational_costs_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT operational_costs_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: operational_costs operational_costs_paid_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT operational_costs_paid_by_fkey FOREIGN KEY (paid_by) REFERENCES public.users(id);


--
-- Name: operational_costs operational_costs_tree_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operational_costs
    ADD CONSTRAINT operational_costs_tree_id_fkey FOREIGN KEY (tree_id) REFERENCES public.trees(id);


--
-- Name: photos photos_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: reports reports_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: reports reports_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(id);


--
-- Name: tree_care_records tree_care_records_care_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT tree_care_records_care_activity_id_fkey FOREIGN KEY (care_activity_id) REFERENCES public.care_activities(id);


--
-- Name: tree_care_records tree_care_records_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT tree_care_records_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id);


--
-- Name: tree_care_records tree_care_records_tree_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tree_care_records
    ADD CONSTRAINT tree_care_records_tree_id_fkey FOREIGN KEY (tree_id) REFERENCES public.trees(id);


--
-- Name: trees trees_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT trees_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(id);


--
-- Name: trees trees_planted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT trees_planted_by_fkey FOREIGN KEY (planted_by) REFERENCES public.users(id);


--
-- Name: trees trees_tree_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trees
    ADD CONSTRAINT trees_tree_type_id_fkey FOREIGN KEY (tree_type_id) REFERENCES public.tree_types(id);


--
-- Name: users users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.user_roles(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users admin_full_access_users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY admin_full_access_users ON public.users TO authenticated USING (public.is_admin());


--
-- Name: areas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.areas ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: care_activities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.care_activities ENABLE ROW LEVEL SECURITY;

--
-- Name: harvest_records; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.harvest_records ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: operational_costs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.operational_costs ENABLE ROW LEVEL SECURITY;

--
-- Name: photos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.photos ENABLE ROW LEVEL SECURITY;

--
-- Name: reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

--
-- Name: tree_care_records; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tree_care_records ENABLE ROW LEVEL SECURITY;

--
-- Name: tree_types; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.tree_types ENABLE ROW LEVEL SECURITY;

--
-- Name: trees; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.trees ENABLE ROW LEVEL SECURITY;

--
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO postgres;


--
-- Name: FUNCTION analyze_productivity(area_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.analyze_productivity(area_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.analyze_productivity(area_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.analyze_productivity(area_uuid uuid) TO service_role;


--
-- Name: FUNCTION audit_trigger_function(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.audit_trigger_function() TO anon;
GRANT ALL ON FUNCTION public.audit_trigger_function() TO authenticated;
GRANT ALL ON FUNCTION public.audit_trigger_function() TO service_role;


--
-- Name: FUNCTION auth_user_role(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.auth_user_role() TO anon;
GRANT ALL ON FUNCTION public.auth_user_role() TO authenticated;
GRANT ALL ON FUNCTION public.auth_user_role() TO service_role;


--
-- Name: FUNCTION auto_generate_tree_barcode(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.auto_generate_tree_barcode() TO anon;
GRANT ALL ON FUNCTION public.auto_generate_tree_barcode() TO authenticated;
GRANT ALL ON FUNCTION public.auto_generate_tree_barcode() TO service_role;


--
-- Name: FUNCTION calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_next_care_due_date(tree_uuid uuid, care_activity_uuid uuid) TO service_role;


--
-- Name: FUNCTION calculate_roi(entity_type text, entity_uuid uuid, date_from date, date_to date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calculate_roi(entity_type text, entity_uuid uuid, date_from date, date_to date) TO anon;
GRANT ALL ON FUNCTION public.calculate_roi(entity_type text, entity_uuid uuid, date_from date, date_to date) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_roi(entity_type text, entity_uuid uuid, date_from date, date_to date) TO service_role;


--
-- Name: FUNCTION calculate_tree_age_months(planting_date date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calculate_tree_age_months(planting_date date) TO anon;
GRANT ALL ON FUNCTION public.calculate_tree_age_months(planting_date date) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_tree_age_months(planting_date date) TO service_role;


--
-- Name: FUNCTION calculate_tree_costs(tree_uuid uuid, date_from date, date_to date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date, date_to date) TO anon;
GRANT ALL ON FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date, date_to date) TO authenticated;
GRANT ALL ON FUNCTION public.calculate_tree_costs(tree_uuid uuid, date_from date, date_to date) TO service_role;


--
-- Name: FUNCTION cleanup_expired_notifications_trigger(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.cleanup_expired_notifications_trigger() TO anon;
GRANT ALL ON FUNCTION public.cleanup_expired_notifications_trigger() TO authenticated;
GRANT ALL ON FUNCTION public.cleanup_expired_notifications_trigger() TO service_role;


--
-- Name: FUNCTION create_automatic_notification(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_automatic_notification() TO anon;
GRANT ALL ON FUNCTION public.create_automatic_notification() TO authenticated;
GRANT ALL ON FUNCTION public.create_automatic_notification() TO service_role;


--
-- Name: FUNCTION daily_notification_cleanup(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.daily_notification_cleanup() TO anon;
GRANT ALL ON FUNCTION public.daily_notification_cleanup() TO authenticated;
GRANT ALL ON FUNCTION public.daily_notification_cleanup() TO service_role;


--
-- Name: FUNCTION generate_automatic_report(report_type text, area_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_automatic_report(report_type text, area_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.generate_automatic_report(report_type text, area_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.generate_automatic_report(report_type text, area_uuid uuid) TO service_role;


--
-- Name: FUNCTION generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date) TO anon;
GRANT ALL ON FUNCTION public.generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date) TO authenticated;
GRANT ALL ON FUNCTION public.generate_report_data(report_type text, area_uuid uuid, date_from date, date_to date) TO service_role;


--
-- Name: FUNCTION generate_tree_barcode(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.generate_tree_barcode() TO anon;
GRANT ALL ON FUNCTION public.generate_tree_barcode() TO authenticated;
GRANT ALL ON FUNCTION public.generate_tree_barcode() TO service_role;


--
-- Name: FUNCTION get_care_activity_summary(area_uuid uuid, date_from date, date_to date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_care_activity_summary(area_uuid uuid, date_from date, date_to date) TO anon;
GRANT ALL ON FUNCTION public.get_care_activity_summary(area_uuid uuid, date_from date, date_to date) TO authenticated;
GRANT ALL ON FUNCTION public.get_care_activity_summary(area_uuid uuid, date_from date, date_to date) TO service_role;


--
-- Name: FUNCTION get_harvest_summary(area_uuid uuid, date_from date, date_to date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_harvest_summary(area_uuid uuid, date_from date, date_to date) TO anon;
GRANT ALL ON FUNCTION public.get_harvest_summary(area_uuid uuid, date_from date, date_to date) TO authenticated;
GRANT ALL ON FUNCTION public.get_harvest_summary(area_uuid uuid, date_from date, date_to date) TO service_role;


--
-- Name: FUNCTION get_overdue_care_activities(area_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_overdue_care_activities(area_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.get_overdue_care_activities(area_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_overdue_care_activities(area_uuid uuid) TO service_role;


--
-- Name: FUNCTION get_tree_productivity_rating(tree_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_tree_productivity_rating(tree_uuid uuid) TO service_role;


--
-- Name: FUNCTION has_area_access(area_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_area_access(area_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.has_area_access(area_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.has_area_access(area_uuid uuid) TO service_role;


--
-- Name: FUNCTION has_permission(permission_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_permission(permission_name text) TO anon;
GRANT ALL ON FUNCTION public.has_permission(permission_name text) TO authenticated;
GRANT ALL ON FUNCTION public.has_permission(permission_name text) TO service_role;


--
-- Name: FUNCTION is_admin(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_admin() TO anon;
GRANT ALL ON FUNCTION public.is_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_admin() TO service_role;


--
-- Name: FUNCTION monthly_productivity_reports(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.monthly_productivity_reports() TO anon;
GRANT ALL ON FUNCTION public.monthly_productivity_reports() TO authenticated;
GRANT ALL ON FUNCTION public.monthly_productivity_reports() TO service_role;


--
-- Name: FUNCTION quarterly_cost_analysis(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.quarterly_cost_analysis() TO anon;
GRANT ALL ON FUNCTION public.quarterly_cost_analysis() TO authenticated;
GRANT ALL ON FUNCTION public.quarterly_cost_analysis() TO service_role;


--
-- Name: FUNCTION tree_needs_care(tree_uuid uuid, care_activity_uuid uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.tree_needs_care(tree_uuid uuid, care_activity_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.tree_needs_care(tree_uuid uuid, care_activity_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.tree_needs_care(tree_uuid uuid, care_activity_uuid uuid) TO service_role;


--
-- Name: FUNCTION update_tree_status_from_care(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_tree_status_from_care() TO anon;
GRANT ALL ON FUNCTION public.update_tree_status_from_care() TO authenticated;
GRANT ALL ON FUNCTION public.update_tree_status_from_care() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION user_managed_areas(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.user_managed_areas() TO anon;
GRANT ALL ON FUNCTION public.user_managed_areas() TO authenticated;
GRANT ALL ON FUNCTION public.user_managed_areas() TO service_role;


--
-- Name: FUNCTION validate_coordinates(coordinates jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.validate_coordinates(coordinates jsonb) TO anon;
GRANT ALL ON FUNCTION public.validate_coordinates(coordinates jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.validate_coordinates(coordinates jsonb) TO service_role;


--
-- Name: FUNCTION validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) TO anon;
GRANT ALL ON FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) TO authenticated;
GRANT ALL ON FUNCTION public.validate_harvest_quantity(tree_uuid uuid, quantity numeric, harvest_date date) TO service_role;


--
-- Name: FUNCTION validate_planting_date(planting_date date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.validate_planting_date(planting_date date) TO anon;
GRANT ALL ON FUNCTION public.validate_planting_date(planting_date date) TO authenticated;
GRANT ALL ON FUNCTION public.validate_planting_date(planting_date date) TO service_role;


--
-- Name: FUNCTION weekly_care_due_notifications(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.weekly_care_due_notifications() TO anon;
GRANT ALL ON FUNCTION public.weekly_care_due_notifications() TO authenticated;
GRANT ALL ON FUNCTION public.weekly_care_due_notifications() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE areas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.areas TO anon;
GRANT ALL ON TABLE public.areas TO authenticated;
GRANT ALL ON TABLE public.areas TO service_role;


--
-- Name: TABLE audit_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_logs TO anon;
GRANT ALL ON TABLE public.audit_logs TO authenticated;
GRANT ALL ON TABLE public.audit_logs TO service_role;


--
-- Name: TABLE care_activities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.care_activities TO anon;
GRANT ALL ON TABLE public.care_activities TO authenticated;
GRANT ALL ON TABLE public.care_activities TO service_role;


--
-- Name: TABLE harvest_records; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.harvest_records TO anon;
GRANT ALL ON TABLE public.harvest_records TO authenticated;
GRANT ALL ON TABLE public.harvest_records TO service_role;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO anon;
GRANT ALL ON TABLE public.notifications TO authenticated;
GRANT ALL ON TABLE public.notifications TO service_role;


--
-- Name: TABLE operational_costs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.operational_costs TO anon;
GRANT ALL ON TABLE public.operational_costs TO authenticated;
GRANT ALL ON TABLE public.operational_costs TO service_role;


--
-- Name: TABLE photos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.photos TO anon;
GRANT ALL ON TABLE public.photos TO authenticated;
GRANT ALL ON TABLE public.photos TO service_role;


--
-- Name: TABLE reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reports TO anon;
GRANT ALL ON TABLE public.reports TO authenticated;
GRANT ALL ON TABLE public.reports TO service_role;


--
-- Name: TABLE tree_care_records; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tree_care_records TO anon;
GRANT ALL ON TABLE public.tree_care_records TO authenticated;
GRANT ALL ON TABLE public.tree_care_records TO service_role;


--
-- Name: TABLE tree_types; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tree_types TO anon;
GRANT ALL ON TABLE public.tree_types TO authenticated;
GRANT ALL ON TABLE public.tree_types TO service_role;


--
-- Name: TABLE trees; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.trees TO anon;
GRANT ALL ON TABLE public.trees TO authenticated;
GRANT ALL ON TABLE public.trees TO service_role;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

