-- ============================================================
-- 0) Asegurar columna allowed_tenants en profiles
-- ============================================================
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS allowed_tenants text[] NOT NULL DEFAULT '{}'::text[];

-- ============================================================
-- 1) Helpers (SECURITY DEFINER) para RLS
-- ============================================================
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND lower(coalesce(p.role, '')) = 'admin'
  );
$$;

CREATE OR REPLACE FUNCTION public.has_tenant_access(tenant text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
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

-- ============================================================
-- 2) RLS para PROFILES (para que USER pueda leer su propio perfil)
-- ============================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS profiles_select_own_or_admin ON public.profiles;
CREATE POLICY profiles_select_own_or_admin
ON public.profiles
FOR SELECT
TO authenticated
USING (id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS profiles_update_own_or_admin ON public.profiles;
CREATE POLICY profiles_update_own_or_admin
ON public.profiles
FOR UPDATE
TO authenticated
USING (id = auth.uid() OR public.is_admin())
WITH CHECK (id = auth.uid() OR public.is_admin());

-- (Opcional) admin puede ver todo (si tienes pantallas de admin que lo requieren)
-- DROP POLICY IF EXISTS profiles_admin_all ON public.profiles;
-- CREATE POLICY profiles_admin_all
-- ON public.profiles
-- FOR ALL
-- TO authenticated
-- USING (public.is_admin())
-- WITH CHECK (public.is_admin());

-- ============================================================
-- 3) Grants básicos (por si falta privilegio además de RLS)
-- ============================================================
GRANT USAGE ON SCHEMA finanzas TO authenticated;
GRANT USAGE ON SCHEMA finanzas_casadepiedra TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finanzas TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finanzas_casadepiedra TO authenticated;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas TO authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas_casadepiedra TO authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA finanzas GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA finanzas_casadepiedra GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO authenticated;

-- ============================================================
-- 4) Políticas por tenant (FINANZAS = plaza_mayor)
-- ============================================================
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['espacios','cotizaciones','documentos','clientes'] LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='finanzas' AND table_name=t) THEN
      EXECUTE format('ALTER TABLE finanzas.%I ENABLE ROW LEVEL SECURITY;', t);

      EXECUTE format('DROP POLICY IF EXISTS %I_select ON finanzas.%I;', 'pm_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_select
        ON finanzas.%I
        FOR SELECT
        TO authenticated
        USING (public.has_tenant_access('plaza_mayor'));
      $pol$, 'pm_'||t, t);

      EXECUTE format('DROP POLICY IF EXISTS %I_write ON finanzas.%I;', 'pm_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_write
        ON finanzas.%I
        FOR INSERT
        TO authenticated
        WITH CHECK (public.has_tenant_access('plaza_mayor'));
      $pol$, 'pm_'||t, t);

      EXECUTE format($pol$
        DROP POLICY IF EXISTS %I_update ON finanzas.%I;
        CREATE POLICY %I_update
        ON finanzas.%I
        FOR UPDATE
        TO authenticated
        USING (public.has_tenant_access('plaza_mayor'))
        WITH CHECK (public.has_tenant_access('plaza_mayor'));
      $pol$, 'pm_'||t, t, 'pm_'||t, t);

      EXECUTE format($pol$
        DROP POLICY IF EXISTS %I_delete ON finanzas.%I;
        CREATE POLICY %I_delete
        ON finanzas.%I
        FOR DELETE
        TO authenticated
        USING (public.has_tenant_access('plaza_mayor'));
      $pol$, 'pm_'||t, t, 'pm_'||t, t);
    END IF;
  END LOOP;

  -- Config tables: lectura para usuarios del tenant, escritura SOLO admin
  FOREACH t IN ARRAY ARRAY['conceptos_catalogo','impuestos'] LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='finanzas' AND table_name=t) THEN
      EXECUTE format('ALTER TABLE finanzas.%I ENABLE ROW LEVEL SECURITY;', t);

      EXECUTE format('DROP POLICY IF EXISTS %I_select ON finanzas.%I;', 'pm_cfg_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_select
        ON finanzas.%I
        FOR SELECT
        TO authenticated
        USING (public.has_tenant_access('plaza_mayor'));
      $pol$, 'pm_cfg_'||t, t);

      EXECUTE format('DROP POLICY IF EXISTS %I_admin_write ON finanzas.%I;', 'pm_cfg_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_admin_write
        ON finanzas.%I
        FOR ALL
        TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $pol$, 'pm_cfg_'||t, t);
    END IF;
  END LOOP;
END $$;

-- ============================================================
-- 5) Políticas por tenant (CASA DE PIEDRA = casa_de_piedra)
-- ============================================================
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['espacios','cotizaciones','documentos','clientes'] LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='finanzas_casadepiedra' AND table_name=t) THEN
      EXECUTE format('ALTER TABLE finanzas_casadepiedra.%I ENABLE ROW LEVEL SECURITY;', t);

      EXECUTE format('DROP POLICY IF EXISTS %I_select ON finanzas_casadepiedra.%I;', 'cp_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_select
        ON finanzas_casadepiedra.%I
        FOR SELECT
        TO authenticated
        USING (public.has_tenant_access('casa_de_piedra'));
      $pol$, 'cp_'||t, t);

      EXECUTE format('DROP POLICY IF EXISTS %I_write ON finanzas_casadepiedra.%I;', 'cp_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_write
        ON finanzas_casadepiedra.%I
        FOR INSERT
        TO authenticated
        WITH CHECK (public.has_tenant_access('casa_de_piedra'));
      $pol$, 'cp_'||t, t);

      EXECUTE format($pol$
        DROP POLICY IF EXISTS %I_update ON finanzas_casadepiedra.%I;
        CREATE POLICY %I_update
        ON finanzas_casadepiedra.%I
        FOR UPDATE
        TO authenticated
        USING (public.has_tenant_access('casa_de_piedra'))
        WITH CHECK (public.has_tenant_access('casa_de_piedra'));
      $pol$, 'cp_'||t, t, 'cp_'||t, t);

      EXECUTE format($pol$
        DROP POLICY IF EXISTS %I_delete ON finanzas_casadepiedra.%I;
        CREATE POLICY %I_delete
        ON finanzas_casadepiedra.%I
        FOR DELETE
        TO authenticated
        USING (public.has_tenant_access('casa_de_piedra'));
      $pol$, 'cp_'||t, t, 'cp_'||t, t);
    END IF;
  END LOOP;

  -- Config tables: lectura para usuarios del tenant, escritura SOLO admin
  FOREACH t IN ARRAY ARRAY['conceptos_catalogo','impuestos'] LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='finanzas_casadepiedra' AND table_name=t) THEN
      EXECUTE format('ALTER TABLE finanzas_casadepiedra.%I ENABLE ROW LEVEL SECURITY;', t);

      EXECUTE format('DROP POLICY IF EXISTS %I_select ON finanzas_casadepiedra.%I;', 'cp_cfg_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_select
        ON finanzas_casadepiedra.%I
        FOR SELECT
        TO authenticated
        USING (public.has_tenant_access('casa_de_piedra'));
      $pol$, 'cp_cfg_'||t, t);

      EXECUTE format('DROP POLICY IF EXISTS %I_admin_write ON finanzas_casadepiedra.%I;', 'cp_cfg_'||t, t);
      EXECUTE format($pol$
        CREATE POLICY %I_admin_write
        ON finanzas_casadepiedra.%I
        FOR ALL
        TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $pol$, 'cp_cfg_'||t, t);
    END IF;
  END LOOP;
END $$;
