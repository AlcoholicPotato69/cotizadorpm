-- ============================================================
-- 1) Grants mínimos (por si faltan)
-- ============================================================
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT ON TABLE public.profiles TO authenticated;

GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE storage.objects TO authenticated;

-- ============================================================
-- 2) Helpers CORRECTOS (evitan que RLS bloquee el helper)
--    IMPORTANTE: SET row_security = off
-- ============================================================
CREATE OR REPLACE FUNCTION public.profile_role()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT lower(coalesce(p.role,''))
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT public.profile_role() = 'admin';
$$;

CREATE OR REPLACE FUNCTION public.can_access_pm()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT public.profile_role() IN ('admin','plaza_mayor','ambos');
$$;

CREATE OR REPLACE FUNCTION public.can_access_cp()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT public.profile_role() IN ('admin','casa_de_piedra','ambos');
$$;

-- ============================================================
-- 3) Reinstalar policies de Storage (buckets: documentos / documentos-cp)
-- ============================================================
DROP POLICY IF EXISTS pm_docs_select  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_insert  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_update  ON storage.objects;
DROP POLICY IF EXISTS pm_docs_delete  ON storage.objects;

DROP POLICY IF EXISTS cp_docs_select  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_insert  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_update  ON storage.objects;
DROP POLICY IF EXISTS cp_docs_delete  ON storage.objects;

-- PLAZA MAYOR bucket: documentos
CREATE POLICY pm_docs_select
ON storage.objects
FOR SELECT TO authenticated
USING (bucket_id = 'documentos' AND public.can_access_pm());

CREATE POLICY pm_docs_insert
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'documentos' AND public.can_access_pm());

CREATE POLICY pm_docs_update
ON storage.objects
FOR UPDATE TO authenticated
USING (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()))
WITH CHECK (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()));

CREATE POLICY pm_docs_delete
ON storage.objects
FOR DELETE TO authenticated
USING (bucket_id = 'documentos' AND (public.is_admin() OR owner = auth.uid()));

-- CASA DE PIEDRA bucket: documentos-cp
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
