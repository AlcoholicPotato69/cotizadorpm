-- 1) Drop todas las policies en ambos schemas (evita duplicadas)
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

-- 2) Re-crear policies en finanzas (Plaza Mayor)
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='finanzas' LOOP
    EXECUTE format('ALTER TABLE finanzas.%I ENABLE ROW LEVEL SECURITY;', r.tablename);

    IF r.tablename IN ('conceptos_catalogo','impuestos') THEN
      -- SELECT: cualquiera con acceso PM (incluye admin)
      EXECUTE format($sql$
        CREATE POLICY fin_%I_select
        ON finanzas.%I
        FOR SELECT TO authenticated
        USING (public.can_access_pm());
      $sql$, r.tablename, r.tablename);

      -- INSERT/UPDATE/DELETE: solo admin (sin SELECT aquí para no duplicar)
      EXECUTE format($sql$
        CREATE POLICY fin_%I_admin_insert
        ON finanzas.%I
        FOR INSERT TO authenticated
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_%I_admin_update
        ON finanzas.%I
        FOR UPDATE TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY fin_%I_admin_delete
        ON finanzas.%I
        FOR DELETE TO authenticated
        USING (public.is_admin());
      $sql$, r.tablename, r.tablename);

    ELSE
      -- Tablas normales: CRUD por acceso PM
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

-- 3) Re-crear policies en finanzas_casadepiedra (Casa de Piedra)
DO $$
DECLARE r record;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='finanzas_casadepiedra' LOOP
    EXECUTE format('ALTER TABLE finanzas_casadepiedra.%I ENABLE ROW LEVEL SECURITY;', r.tablename);

    IF r.tablename IN ('conceptos_catalogo','impuestos') THEN
      EXECUTE format($sql$
        CREATE POLICY cp_%I_select
        ON finanzas_casadepiedra.%I
        FOR SELECT TO authenticated
        USING (public.can_access_cp());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_admin_insert
        ON finanzas_casadepiedra.%I
        FOR INSERT TO authenticated
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_admin_update
        ON finanzas_casadepiedra.%I
        FOR UPDATE TO authenticated
        USING (public.is_admin())
        WITH CHECK (public.is_admin());
      $sql$, r.tablename, r.tablename);

      EXECUTE format($sql$
        CREATE POLICY cp_%I_admin_delete
        ON finanzas_casadepiedra.%I
        FOR DELETE TO authenticated
        USING (public.is_admin());
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
