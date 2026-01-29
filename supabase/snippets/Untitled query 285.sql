-- ============================================================
-- 1) Asegurar columnas
-- ============================================================
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS role text DEFAULT 'user';

ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS allowed_tenants text[] NOT NULL DEFAULT '{}'::text[];

-- ============================================================
-- 2) Helpers (SECURITY DEFINER) para evitar que RLS bloquee el helper
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
  SELECT
    public.profile_role() IN ('admin','plaza_mayor','ambos')
    OR EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND 'plaza_mayor' = ANY (SELECT lower(x) FROM unnest(p.allowed_tenants) x)
    );
$$;

CREATE OR REPLACE FUNCTION public.can_access_cp()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
SET row_security = off
AS $$
  SELECT
    public.profile_role() IN ('admin','casa_de_piedra','ambos')
    OR EXISTS (
      SELECT 1 FROM public.profiles p
      WHERE p.id = auth.uid()
        AND 'casa_de_piedra' = ANY (SELECT lower(x) FROM unnest(p.allowed_tenants) x)
    );
$$;

-- ============================================================
-- 3) profiles: que el sistema SI pueda leer el perfil (si no, dashboard queda vacío)
-- ============================================================
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT SELECT, UPDATE ON TABLE public.profiles TO authenticated;

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE pol record;
BEGIN
  FOR pol IN SELECT policyname FROM pg_policies WHERE schemaname='public' AND tablename='profiles' LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.profiles;', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY profiles_select_self_or_admin
ON public.profiles
FOR SELECT TO authenticated
USING (id = auth.uid() OR public.is_admin());

CREATE POLICY profiles_update_self_or_admin
ON public.profiles
FOR UPDATE TO authenticated
USING (id = auth.uid() OR public.is_admin())
WITH CHECK (id = auth.uid() OR public.is_admin());

-- ============================================================
-- 4) Grants schema + tablas (necesarios además de RLS)
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
-- 5) BORRAR TODAS las policies RLS de ambos schemas (para no mezclar)
-- ============================================================
DO $$
DECLARE p record;
BEGIN
  FOR p IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname IN ('finanzas','finanzas_casadepiedra')
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I;', p.policyname, p.schemaname, p.tablename);
  END LOOP;
END $$;

-- ============================================================
-- 6) Policies finanzas (Plaza Mayor)
--    - Todas las tablas: CRUD para can_access_pm()
--    - Excepto config: conceptos_catalogo/impuestos (solo admin escribe)
-- ============================================================
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='finanzas' LOOP
    EXECUTE format('ALTER TABLE finanzas.%I ENABLE ROW LEVEL SECURITY;', r.tablename);

    IF r.tablename IN ('conceptos_catalogo','impuestos') THEN
      EXECUTE format($sql$
        CREATE POLICY fin_cfg_%I_select
        ON finanzas.%I
        FOR SELECT TO authenticated
        USING (public.can_access_pm());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_cfg_%I_admin_all
        ON finanzas.%I
        FOR ALL TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

    ELSE
      EXECUTE format($sql$
        CREATE POLICY fin_%I_select
        ON finanzas.%I
        FOR SELECT TO authenticated
        USING (public.can_access_pm());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_%I_insert
        ON finanzas.%I
        FOR INSERT TO authenticated
        WITH CHECK (public.can_access_pm());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_%I_update
        ON finanzas.%I
        FOR UPDATE TO authenticated
        USING (public.can_access_pm())
        WITH CHECK (public.can_access_pm());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_%I_delete
        ON finanzas.%I
        FOR DELETE TO authenticated
        USING (public.can_access_pm());
      $sql$, r.tablename, r.tablename);
    END IF;
  END LOOP;
END $$;

-- ============================================================
-- 7) Policies finanzas_casadepiedra (Casa de Piedra)
-- ============================================================
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='finanzas_casadepiedra' LOOP
    EXECUTE format('ALTER TABLE finanzas_casadepiedra.%I ENABLE ROW LEVEL SECURITY;', r.tablename);

    IF r.tablename IN ('conceptos_catalogo','impuestos') THEN
      EXECUTE format($sql$
        CREATE POLICY cp_cfg_%I_select
        ON finanzas_casadepiedra.%I
        FOR SELECT TO authenticated
        USING (public.can_access_cp());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_cfg_%I_admin_all
        ON finanzas_casadepiedra.%I
        FOR ALL TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

    ELSE
      EXECUTE format($sql$
        CREATE POLICY cp_%I_select
        ON finanzas_casadepiedra.%I
        FOR SELECT TO authenticated
        USING (public.can_access_cp());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_insert
        ON finanzas_casadepiedra.%I
        FOR INSERT TO authenticated
        WITH CHECK (public.can_access_cp());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_update
        ON finanzas_casadepiedra.%I
        FOR UPDATE TO authenticated
        USING (public.can_access_cp())
        WITH CHECK (public.can_access_cp());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_delete
        ON finanzas_casadepiedra.%I
        FOR DELETE TO authenticated
        USING (public.can_access_cp());
      $sql$, r.tablename, r.tablename);
    END IF;
  END LOOP;
END $$;
