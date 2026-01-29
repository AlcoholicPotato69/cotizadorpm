-- Finanzas (Plaza Mayor)
DROP POLICY IF EXISTS "tenant_isolation_pm" ON finanzas.cotizaciones;
CREATE POLICY "tenant_isolation_pm" ON finanzas.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('Plaza Mayor') );

-- Finanzas Casa de Piedra
DROP POLICY IF EXISTS "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones;
CREATE POLICY "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('Casa de Piedra') );

NOTIFY pgrst, 'reload config';