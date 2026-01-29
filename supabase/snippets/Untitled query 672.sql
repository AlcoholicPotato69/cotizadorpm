-- ============================================================
-- 1) Normalizador (convierte "Plaza Mayor" -> "plaza_mayor")
-- ============================================================
CREATE OR REPLACE FUNCTION public.normalize_key(t text)
RETURNS text
LANGUAGE sql
IMMUTABLE
AS $$
  SELECT trim(both '_' FROM regexp_replace(lower(coalesce(t,'')), '[^a-z0-9]+', '_', 'g'));
$$;

-- ============================================================
-- 2) Leer rol/tenants desde profiles SIN que RLS lo bloquee
-- ============================================================
CREATE OR REPLACE FUNCTION public.profile_role_norm()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT public.normalize_key(p.role)
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.profile_has_tenant_norm(tenant text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
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

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT public.profile_role_norm() = 'admin';
$$;

-- Acceso PM: rol plaza_mayor / ambos / admin, o allowed_tenants contiene plaza_mayor
CREATE OR REPLACE FUNCTION public.can_access_pm()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','plaza_mayor')
    OR public.profile_has_tenant_norm('plaza_mayor');
$$;

-- Acceso CP: rol casa_de_piedra / ambos / admin, o allowed_tenants contiene casa_de_piedra
CREATE OR REPLACE FUNCTION public.can_access_cp()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','casa_de_piedra')
    OR public.profile_has_tenant_norm('casa_de_piedra');
$$;

-- ============================================================
-- 3) Grants necesarios
-- ============================================================
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON TABLE public.profiles TO authenticated;

GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE storage.objects TO authenticated;

-- ============================================================
-- 4) Buckets (asegura que existan)
-- ============================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('documentos', 'documentos', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
VALUES ('documentos-cp', 'documentos-cp', false)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- 5) Reinstalar policies de Storage
-- ============================================================
DROP POLICY IF EXISTS pm_docs_select  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_insert  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_update  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_delete  ON storage.objects;

DROP POLICY IF EXISTS cp_docs_select  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_insert  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_update  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_delete  ON storage.objects;

-- Plaza Mayor -> bucket documentos
CREATE POLICY pm_docs_select
ON storage.objects
FOR SELECT TO authenticated
USING (bucket_id = 'documentos' AND public.can_access_pm());

CREATE POLICY pm_docs_insert
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'documentos' AND public.can_access_pm());

-- Update/Delete: admin o dueño
CREATE POLICY pm_docs_update
ON storage.objects
FOR UPDATE TO authenticated
USING (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()))
WITH CHECK (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()));

CREATE POLICY pm_docs_delete
ON storage.objects
FOR DELETE TO authenticated
USING (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()));

-- Casa de Piedra -> bucket documentos-cp
CREATE POLICY cp_docs_select
ON storage.objects
FOR SELECT TO authenticated
USING (bucket_id = 'documentos-cp' AND public.can_access_cp());

CREATE POLICY cp_docs_insert
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'documentos-cp' AND public.can_access_cp());

CREATE POLICY cp_docs_update
ON storage.objects
FOR UPDATE TO authenticated
USING (bucket_id = 'documentos-cp' AND (public.is_admin() OR owner = auth.uid()))
WITH CHECK (bucket_id = 'documentos-cp' AND (public.is_admin() OR owner = auth.uid()));

CREATE POLICY cp_docs_delete
ON storage.objects
FOR DELETE TO authenticated
USING (bucket_id = 'documentos-cp' AND (public.is_admin() OR owner = auth.uid()));
