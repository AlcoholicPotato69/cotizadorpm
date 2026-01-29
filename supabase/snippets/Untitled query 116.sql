-- ============================================================
-- 0) Asegurar buckets (no los hace públicos)
-- ============================================================
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('documentos', 'documentos', false),
  ('documentos-cp', 'documentos-cp', false)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;

-- ============================================================
-- 1) Limpieza de policies anteriores (si existen)
-- ============================================================
DO $$
DECLARE p record;
BEGIN
  FOR p IN
    SELECT policyname
    FROM pg_policies
    WHERE schemaname='storage' AND tablename='objects'
      AND policyname IN (
        'pm_docs_select','pm_docs_insert','pm_docs_update','pm_docs_delete',
        'cp_docs_select','cp_docs_insert','cp_docs_update','cp_docs_delete'
      )
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON storage.objects;', p.policyname);
  END LOOP;
END $$;

-- ============================================================
-- 2) PLAZA MAYOR: bucket "documentos"
-- ============================================================

-- Leer (descargar/preview)
CREATE POLICY pm_docs_select
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'documentos'
  AND public.can_access_pm()
);

-- Subir (crear objetos)
CREATE POLICY pm_docs_insert
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documentos'
  AND public.can_access_pm()
);

-- Actualizar metadata o mover rutas: solo dueño o admin (recomendado)
CREATE POLICY pm_docs_update
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'documentos'
  AND ( public.is_admin() OR owner = auth.uid() )
)
WITH CHECK (
  bucket_id = 'documentos'
  AND ( public.is_admin() OR owner = auth.uid() )
);

-- Borrar: solo dueño o admin (recomendado)
CREATE POLICY pm_docs_delete
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'documentos'
  AND ( public.is_admin() OR owner = auth.uid() )
);

-- ============================================================
-- 3) CASA DE PIEDRA: bucket "documentos-cp"
-- ============================================================

CREATE POLICY cp_docs_select
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'documentos-cp'
  AND public.can_access_cp()
);

CREATE POLICY cp_docs_insert
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documentos-cp'
  AND public.can_access_cp()
);

CREATE POLICY cp_docs_update
ON storage.objects
FOR UPDATE
TO authenticated
USING (
  bucket_id = 'documentos-cp'
  AND ( public.is_admin() OR owner = auth.uid() )
)
WITH CHECK (
  bucket_id = 'documentos-cp'
  AND ( public.is_admin() OR owner = auth.uid() )
);

CREATE POLICY cp_docs_delete
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'documentos-cp'
  AND ( public.is_admin() OR owner = auth.uid() )
);
