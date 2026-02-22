--
-- PostgreSQL database dump
--

\restrict MiHCv6eYD8eMVq6UhBIpayMCVUSZVsyuqevSMPDG6MsLW3mKbgygKXmfBBcEFgb

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA finanzas;


--
-- Name: SCHEMA finanzas; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA finanzas IS 'M??dulo de Cotizador (Versi??n Local Independiente)';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: can_access_cp(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_access_cp() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','casa_de_piedra')
    OR public.profile_has_tenant_norm('casa_de_piedra');
$$;


--
-- Name: can_access_pm(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.can_access_pm() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','plaza_mayor')
    OR public.profile_has_tenant_norm('plaza_mayor');
$$;


--
-- Name: get_my_module_access(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_my_module_access() RETURNS jsonb
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select jsonb_build_object(
    'role', coalesce(p.role, 'user'),
    'allowed_tenants', coalesce(p.allowed_tenants, array[]::text[]),
    'show_plaza_mayor', (public.is_admin() or ('plaza_mayor' = any(coalesce(p.allowed_tenants, array[]::text[])))),
    'show_casa_de_piedra', (public.is_admin() or ('casa_de_piedra' = any(coalesce(p.allowed_tenants, array[]::text[]))))
  )
  from public.profiles p
  where p.id = auth.uid();
$$;


--
-- Name: get_my_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_my_role() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth', 'extensions'
    AS $$
DECLARE
  current_role text;
BEGIN
  -- Obtenemos el rol directo del perfil
  SELECT role INTO current_role
  FROM public.profiles
  WHERE id = auth.uid();
  
  RETURN current_role;
END;
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin
  insert into public.profiles (id, email, username, role, allowed_tenants, app_metadata)
  values (
    new.id,
    new.email,
    coalesce(split_part(new.email, '@', 1), 'Usuario'),
    'user',
    array['plaza_mayor']::text[],
    '{}'::jsonb
  )
  on conflict (id) do nothing;

  return new;
end;
$$;


--
-- Name: handle_new_user_profile(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user_profile() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'auth', 'extensions'
    AS $$
begin
  insert into public.profiles (id, username, role, app_metadata)
  values (new.id, split_part(new.email, '@', 1), 'admin', '{}'::jsonb)
  on conflict (id) do nothing;
  return new;
end;
$$;


--
-- Name: has_tenant_access(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_tenant_access(tenant text) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND (
        lower(coalesce(p.role,'')) = 'admin'
        OR lower(tenant) = ANY (SELECT lower(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x)
      )
  );
$$;


--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT public.profile_role_norm() = 'admin';
$$;


--
-- Name: jwt_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.jwt_role() RETURNS text
    LANGUAGE sql STABLE
    SET search_path TO 'public', 'extensions'
    AS $$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$$;


--
-- Name: normalize_key(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.normalize_key(t text) RETURNS text
    LANGUAGE sql IMMUTABLE
    SET search_path TO 'public'
    AS $$
  SELECT trim(both '_' FROM regexp_replace(lower(coalesce(t,'')), '[^a-z0-9]+', '_', 'g'));
$$;


--
-- Name: profile_has_tenant_norm(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.profile_has_tenant_norm(tenant text) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND public.normalize_key(tenant) = ANY (
        SELECT public.normalize_key(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x
      )
  );
$$;


--
-- Name: profile_role(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.profile_role() RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT lower(coalesce(p.role,''))
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;


--
-- Name: profile_role_norm(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.profile_role_norm() RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    SET row_security TO 'off'
    AS $$
  SELECT public.normalize_key(p.role)
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;


--
-- Name: rls_auto_enable(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.rls_auto_enable() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'public', 'extensions'
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: finanzas; Owner: -
--

CREATE TABLE finanzas.clientes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nombre_completo text NOT NULL,
    telefono text,
    correo text,
    rfc text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: conceptos_catalogo; Type: TABLE; Schema: finanzas; Owner: -
--

CREATE TABLE finanzas.conceptos_catalogo (
    id bigint NOT NULL,
    nombre text NOT NULL,
    precio_sugerido numeric DEFAULT 0,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY finanzas.conceptos_catalogo FORCE ROW LEVEL SECURITY;


--
-- Name: conceptos_catalogo_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.conceptos_catalogo ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME finanzas.conceptos_catalogo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cotizaciones; Type: TABLE; Schema: finanzas; Owner: -
--

CREATE TABLE finanzas.cotizaciones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    creado_por uuid,
    espacio_id bigint,
    espacio_nombre text,
    espacio_clave text,
    cliente_nombre text,
    cliente_rfc text,
    cliente_contacto text,
    cliente_email text,
    cliente_telefono text,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    precio_final numeric NOT NULL,
    desglose_precios jsonb,
    status text DEFAULT 'aprobada'::text,
    numero_orden text,
    numero_contrato text,
    factura_pdf_url text,
    factura_xml_url text,
    contrato_url text,
    url_cotizacion_final text,
    url_orden_compra text,
    fecha_orden_compra timestamp with time zone,
    datos_fiscales jsonb DEFAULT '{}'::jsonb,
    conceptos_adicionales jsonb DEFAULT '[]'::jsonb,
    tipo_ajuste text DEFAULT 'ninguno'::text,
    valor_ajuste numeric DEFAULT 0,
    ajuste_es_porcentaje boolean DEFAULT false,
    desglose_impuestos jsonb DEFAULT '[]'::jsonb,
    historial_pagos jsonb DEFAULT '[]'::jsonb,
    datos_factura jsonb DEFAULT '{}'::jsonb,
    cliente_id uuid
);

ALTER TABLE ONLY finanzas.cotizaciones FORCE ROW LEVEL SECURITY;


--
-- Name: espacios; Type: TABLE; Schema: finanzas; Owner: -
--

CREATE TABLE finanzas.espacios (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    clave text NOT NULL,
    nombre text NOT NULL,
    tipo text NOT NULL,
    descripcion text,
    requisitos text,
    imagen_url text,
    activo boolean DEFAULT true,
    precio_base numeric DEFAULT 0,
    ajuste_tipo text DEFAULT 'ninguno'::text,
    ajuste_porcentaje integer DEFAULT 0,
    activa boolean DEFAULT true,
    impuestos_ids jsonb DEFAULT '[]'::jsonb,
    color character varying DEFAULT '#374151'::character varying
);

ALTER TABLE ONLY finanzas.espacios FORCE ROW LEVEL SECURITY;


--
-- Name: espacios_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.espacios ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME finanzas.espacios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: impuestos; Type: TABLE; Schema: finanzas; Owner: -
--

CREATE TABLE finanzas.impuestos (
    id bigint NOT NULL,
    nombre text NOT NULL,
    porcentaje numeric NOT NULL,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()),
    impuestos_aplicados jsonb
);

ALTER TABLE ONLY finanzas.impuestos FORCE ROW LEVEL SECURITY;


--
-- Name: impuestos_id_seq; Type: SEQUENCE; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.impuestos ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME finanzas.impuestos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    email text,
    username text,
    role text DEFAULT 'user'::text NOT NULL,
    tenant text DEFAULT 'plaza_mayor'::text NOT NULL,
    app_metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    allowed_tenants text[] DEFAULT ARRAY['plaza_mayor'::text] NOT NULL,
    CONSTRAINT profiles_allowed_tenants_valid CHECK ((allowed_tenants <@ ARRAY['plaza_mayor'::text, 'casa_de_piedra'::text]))
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
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
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: iceberg_namespaces; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_namespaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    catalog_id uuid NOT NULL
);


--
-- Name: iceberg_tables; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.iceberg_tables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    namespace_id uuid NOT NULL,
    bucket_name text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    location text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    remote_table_id text,
    shard_key text,
    shard_id text,
    catalog_id uuid NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
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


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
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


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
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


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: conceptos_catalogo conceptos_catalogo_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.conceptos_catalogo
    ADD CONSTRAINT conceptos_catalogo_pkey PRIMARY KEY (id);


--
-- Name: cotizaciones cotizaciones_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.cotizaciones
    ADD CONSTRAINT cotizaciones_pkey PRIMARY KEY (id);


--
-- Name: espacios espacios_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.espacios
    ADD CONSTRAINT espacios_pkey PRIMARY KEY (id);


--
-- Name: impuestos impuestos_pkey; Type: CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.impuestos
    ADD CONSTRAINT impuestos_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: iceberg_namespaces iceberg_namespaces_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_pkey PRIMARY KEY (id);


--
-- Name: iceberg_tables iceberg_tables_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: idx_finanzas_clientes_correo; Type: INDEX; Schema: finanzas; Owner: -
--

CREATE INDEX idx_finanzas_clientes_correo ON finanzas.clientes USING btree (lower(correo));


--
-- Name: idx_finanzas_clientes_nombre; Type: INDEX; Schema: finanzas; Owner: -
--

CREATE INDEX idx_finanzas_clientes_nombre ON finanzas.clientes USING btree (lower(nombre_completo));


--
-- Name: idx_finanzas_clientes_rfc; Type: INDEX; Schema: finanzas; Owner: -
--

CREATE INDEX idx_finanzas_clientes_rfc ON finanzas.clientes USING btree (rfc);


--
-- Name: idx_finanzas_cotizaciones_cliente_id; Type: INDEX; Schema: finanzas; Owner: -
--

CREATE INDEX idx_finanzas_cotizaciones_cliente_id ON finanzas.cotizaciones USING btree (cliente_id);


--
-- Name: profiles_allowed_tenants_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_allowed_tenants_gin ON public.profiles USING gin (allowed_tenants);


--
-- Name: profiles_email_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_email_idx ON public.profiles USING btree (lower(email));


--
-- Name: profiles_tenant_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX profiles_tenant_idx ON public.profiles USING btree (tenant);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_iceberg_namespaces_bucket_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_namespaces_bucket_id ON storage.iceberg_namespaces USING btree (catalog_id, name);


--
-- Name: idx_iceberg_tables_location; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_location ON storage.iceberg_tables USING btree (location);


--
-- Name: idx_iceberg_tables_namespace_id; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX idx_iceberg_tables_namespace_id ON storage.iceberg_tables USING btree (catalog_id, namespace_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: clientes trg_finanzas_clientes_updated_at; Type: TRIGGER; Schema: finanzas; Owner: -
--

CREATE TRIGGER trg_finanzas_clientes_updated_at BEFORE UPDATE ON finanzas.clientes FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: profiles profiles_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: cotizaciones cotizaciones_cliente_id_fkey; Type: FK CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.cotizaciones
    ADD CONSTRAINT cotizaciones_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES finanzas.clientes(id) ON DELETE SET NULL;


--
-- Name: cotizaciones fk_cotizaciones_espacios; Type: FK CONSTRAINT; Schema: finanzas; Owner: -
--

ALTER TABLE ONLY finanzas.cotizaciones
    ADD CONSTRAINT fk_cotizaciones_espacios FOREIGN KEY (espacio_id) REFERENCES finanzas.espacios(id) ON DELETE SET NULL;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: iceberg_namespaces iceberg_namespaces_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_namespaces
    ADD CONSTRAINT iceberg_namespaces_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_catalog_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES storage.buckets_analytics(id) ON DELETE CASCADE;


--
-- Name: iceberg_tables iceberg_tables_namespace_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.iceberg_tables
    ADD CONSTRAINT iceberg_tables_namespace_id_fkey FOREIGN KEY (namespace_id) REFERENCES storage.iceberg_namespaces(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: espacios Anon_Ve_Espacios_PM; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY "Anon_Ve_Espacios_PM" ON finanzas.espacios FOR SELECT TO anon USING ((activo = true));


--
-- Name: cotizaciones Anon_Ve_Fechas_Ocupadas_PM; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY "Anon_Ve_Fechas_Ocupadas_PM" ON finanzas.cotizaciones FOR SELECT TO anon USING ((status = ANY (ARRAY['aprobada'::text, 'finalizada'::text])));


--
-- Name: espacios Publico_Ve_Espacios_Activos; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY "Publico_Ve_Espacios_Activos" ON finanzas.espacios FOR SELECT TO anon USING ((activo = true));


--
-- Name: clientes; Type: ROW SECURITY; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.clientes ENABLE ROW LEVEL SECURITY;

--
-- Name: conceptos_catalogo; Type: ROW SECURITY; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.conceptos_catalogo ENABLE ROW LEVEL SECURITY;

--
-- Name: cotizaciones; Type: ROW SECURITY; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.cotizaciones ENABLE ROW LEVEL SECURITY;

--
-- Name: espacios; Type: ROW SECURITY; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.espacios ENABLE ROW LEVEL SECURITY;

--
-- Name: clientes fin_clientes_delete; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_clientes_delete ON finanzas.clientes FOR DELETE TO authenticated USING (public.can_access_pm());


--
-- Name: clientes fin_clientes_insert; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_clientes_insert ON finanzas.clientes FOR INSERT TO authenticated WITH CHECK (public.can_access_pm());


--
-- Name: clientes fin_clientes_select; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_clientes_select ON finanzas.clientes FOR SELECT TO authenticated USING (public.can_access_pm());


--
-- Name: clientes fin_clientes_update; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_clientes_update ON finanzas.clientes FOR UPDATE TO authenticated USING (public.can_access_pm()) WITH CHECK (public.can_access_pm());


--
-- Name: conceptos_catalogo fin_conceptos_catalogo_admin_delete; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_conceptos_catalogo_admin_delete ON finanzas.conceptos_catalogo FOR DELETE TO authenticated USING (public.is_admin());


--
-- Name: conceptos_catalogo fin_conceptos_catalogo_admin_insert; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_conceptos_catalogo_admin_insert ON finanzas.conceptos_catalogo FOR INSERT TO authenticated WITH CHECK (public.is_admin());


--
-- Name: conceptos_catalogo fin_conceptos_catalogo_admin_update; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_conceptos_catalogo_admin_update ON finanzas.conceptos_catalogo FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: conceptos_catalogo fin_conceptos_catalogo_select; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_conceptos_catalogo_select ON finanzas.conceptos_catalogo FOR SELECT TO authenticated USING (public.can_access_pm());


--
-- Name: cotizaciones fin_cotizaciones_delete; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_cotizaciones_delete ON finanzas.cotizaciones FOR DELETE TO authenticated USING (public.can_access_pm());


--
-- Name: cotizaciones fin_cotizaciones_insert; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_cotizaciones_insert ON finanzas.cotizaciones FOR INSERT TO authenticated WITH CHECK (public.can_access_pm());


--
-- Name: cotizaciones fin_cotizaciones_select; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_cotizaciones_select ON finanzas.cotizaciones FOR SELECT TO authenticated USING (public.can_access_pm());


--
-- Name: cotizaciones fin_cotizaciones_update; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_cotizaciones_update ON finanzas.cotizaciones FOR UPDATE TO authenticated USING (public.can_access_pm()) WITH CHECK (public.can_access_pm());


--
-- Name: espacios fin_espacios_delete; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_espacios_delete ON finanzas.espacios FOR DELETE TO authenticated USING (public.can_access_pm());


--
-- Name: espacios fin_espacios_insert; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_espacios_insert ON finanzas.espacios FOR INSERT TO authenticated WITH CHECK (public.can_access_pm());


--
-- Name: espacios fin_espacios_select; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_espacios_select ON finanzas.espacios FOR SELECT TO authenticated USING (public.can_access_pm());


--
-- Name: espacios fin_espacios_update; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_espacios_update ON finanzas.espacios FOR UPDATE TO authenticated USING (public.can_access_pm()) WITH CHECK (public.can_access_pm());


--
-- Name: impuestos fin_impuestos_admin_delete; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_impuestos_admin_delete ON finanzas.impuestos FOR DELETE TO authenticated USING (public.is_admin());


--
-- Name: impuestos fin_impuestos_admin_insert; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_impuestos_admin_insert ON finanzas.impuestos FOR INSERT TO authenticated WITH CHECK (public.is_admin());


--
-- Name: impuestos fin_impuestos_admin_update; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_impuestos_admin_update ON finanzas.impuestos FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());


--
-- Name: impuestos fin_impuestos_select; Type: POLICY; Schema: finanzas; Owner: -
--

CREATE POLICY fin_impuestos_select ON finanzas.impuestos FOR SELECT TO authenticated USING (public.can_access_pm());


--
-- Name: impuestos; Type: ROW SECURITY; Schema: finanzas; Owner: -
--

ALTER TABLE finanzas.impuestos ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles_insert_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_insert_own ON public.profiles FOR INSERT TO authenticated WITH CHECK (((id = ( SELECT auth.uid() AS uid)) OR public.is_admin()));


--
-- Name: profiles profiles_select_self_or_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_select_self_or_admin ON public.profiles FOR SELECT TO authenticated USING (((id = ( SELECT auth.uid() AS uid)) OR public.is_admin()));


--
-- Name: profiles profiles_update_self_or_admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_update_self_or_admin ON public.profiles FOR UPDATE TO authenticated USING (((id = ( SELECT auth.uid() AS uid)) OR public.is_admin())) WITH CHECK (((id = ( SELECT auth.uid() AS uid)) OR public.is_admin()));


--
-- Name: objects Authenticated Delete Espacios; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated Delete Espacios" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'Espacios'::text));


--
-- Name: objects Authenticated Insert Espacios; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated Insert Espacios" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'Espacios'::text));


--
-- Name: objects Authenticated Update Espacios; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Authenticated Update Espacios" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'Espacios'::text));


--
-- Name: objects Public Access Espacios; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Public Access Espacios" ON storage.objects FOR SELECT USING ((bucket_id = 'Espacios'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: objects cp_docs_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY cp_docs_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'documentos-cp'::text) AND (public.is_admin() OR (owner = auth.uid()))));


--
-- Name: objects cp_docs_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY cp_docs_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'documentos-cp'::text) AND public.can_access_cp()));


--
-- Name: objects cp_docs_select; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY cp_docs_select ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'documentos-cp'::text) AND public.can_access_cp()));


--
-- Name: objects cp_docs_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY cp_docs_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'documentos-cp'::text) AND (public.is_admin() OR (owner = auth.uid())))) WITH CHECK (((bucket_id = 'documentos-cp'::text) AND (public.is_admin() OR (owner = auth.uid()))));


--
-- Name: iceberg_namespaces; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_namespaces ENABLE ROW LEVEL SECURITY;

--
-- Name: iceberg_tables; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.iceberg_tables ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: objects pm_docs_delete; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pm_docs_delete ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'documentos'::text) AND (public.is_admin() OR (owner = auth.uid()))));


--
-- Name: objects pm_docs_insert; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pm_docs_insert ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'documentos'::text) AND public.can_access_pm()));


--
-- Name: objects pm_docs_select; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pm_docs_select ON storage.objects FOR SELECT TO authenticated USING (((bucket_id = 'documentos'::text) AND public.can_access_pm()));


--
-- Name: objects pm_docs_update; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY pm_docs_update ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'documentos'::text) AND (public.is_admin() OR (owner = auth.uid())))) WITH CHECK (((bucket_id = 'documentos'::text) AND (public.is_admin() OR (owner = auth.uid()))));


--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

\unrestrict MiHCv6eYD8eMVq6UhBIpayMCVUSZVsyuqevSMPDG6MsLW3mKbgygKXmfBBcEFgb

