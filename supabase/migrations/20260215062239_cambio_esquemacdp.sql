set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.can_access_cp()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','casa_de_piedra')
    OR public.profile_has_tenant_norm('casa_de_piedra');
$function$
;

CREATE OR REPLACE FUNCTION public.can_access_pm()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','plaza_mayor')
    OR public.profile_has_tenant_norm('plaza_mayor');
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_module_access()
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select jsonb_build_object(
    'role', coalesce(p.role, 'user'),
    'allowed_tenants', coalesce(p.allowed_tenants, array[]::text[]),
    'show_plaza_mayor', (public.is_admin() or ('plaza_mayor' = any(coalesce(p.allowed_tenants, array[]::text[])))),
    'show_casa_de_piedra', (public.is_admin() or ('casa_de_piedra' = any(coalesce(p.allowed_tenants, array[]::text[]))))
  )
  from public.profiles p
  where p.id = auth.uid();
$function$
;

CREATE OR REPLACE FUNCTION public.get_my_role()
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
DECLARE
  current_role text;
BEGIN
  -- Obtenemos el rol directo del perfil
  SELECT role INTO current_role
  FROM public.profiles
  WHERE id = auth.uid();
  
  RETURN current_role;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user_profile()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public', 'auth', 'extensions'
AS $function$
begin
  insert into public.profiles (id, username, role, app_metadata)
  values (new.id, split_part(new.email, '@', 1), 'admin', '{}'::jsonb)
  on conflict (id) do nothing;
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.has_tenant_access(tenant text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND (
        lower(coalesce(p.role,'')) = 'admin'
        OR lower(tenant) = ANY (SELECT lower(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x)
      )
  );
$function$
;

CREATE OR REPLACE FUNCTION public.is_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT public.profile_role_norm() = 'admin';
$function$
;

CREATE OR REPLACE FUNCTION public.jwt_role()
 RETURNS text
 LANGUAGE sql
 STABLE
 SET search_path TO 'public', 'extensions'
AS $function$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$function$
;

CREATE OR REPLACE FUNCTION public.normalize_key(t text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO 'public'
AS $function$
  SELECT trim(both '_' FROM regexp_replace(lower(coalesce(t,'')), '[^a-z0-9]+', '_', 'g'));
$function$
;

CREATE OR REPLACE FUNCTION public.profile_has_tenant_norm(tenant text)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND public.normalize_key(tenant) = ANY (
        SELECT public.normalize_key(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x
      )
  );
$function$
;

CREATE OR REPLACE FUNCTION public.profile_role()
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT lower(coalesce(p.role,''))
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.profile_role_norm()
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
 SET row_security TO 'off'
AS $function$
  SELECT public.normalize_key(p.role)
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$function$
;

CREATE OR REPLACE FUNCTION public.rls_auto_enable()
 RETURNS event_trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'public', 'extensions'
AS $function$
begin
  new.updated_at = now();
  return new;
end;
$function$
;

grant delete on table "public"."profiles" to "postgres";

grant insert on table "public"."profiles" to "postgres";

grant references on table "public"."profiles" to "postgres";

grant select on table "public"."profiles" to "postgres";

grant trigger on table "public"."profiles" to "postgres";

grant truncate on table "public"."profiles" to "postgres";

grant update on table "public"."profiles" to "postgres";


