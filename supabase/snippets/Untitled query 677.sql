-- === ESQUEMA PLAZA MAYOR (finanzas) ===

-- 1. Cotizaciones (Todo: Select, Insert, Update, Delete)
ALTER TABLE finanzas.cotizaciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pm_policy_all" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "tenant_isolation_pm" ON finanzas.cotizaciones;

CREATE POLICY "pm_policy_all" ON finanzas.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') )
WITH CHECK ( public.can_access_tenant('plaza_mayor') );

-- 2. Espacios
ALTER TABLE finanzas.espacios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pm_espacios_all" ON finanzas.espacios;
DROP POLICY IF EXISTS "tenant_isolation_pm_espacios" ON finanzas.espacios;

CREATE POLICY "pm_espacios_all" ON finanzas.espacios
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') )
WITH CHECK ( public.can_access_tenant('plaza_mayor') );

-- 3. Clientes
ALTER TABLE finanzas.clientes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pm_clientes_all" ON finanzas.clientes;
DROP POLICY IF EXISTS "tenant_isolation_pm_clientes" ON finanzas.clientes;

CREATE POLICY "pm_clientes_all" ON finanzas.clientes
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') )
WITH CHECK ( public.can_access_tenant('plaza_mayor') );


-- === ESQUEMA CASA DE PIEDRA (finanzas_casadepiedra) ===

-- 1. Cotizaciones CP
ALTER TABLE finanzas_casadepiedra.cotizaciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "cp_policy_all" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones;

CREATE POLICY "cp_policy_all" ON finanzas_casadepiedra.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') )
WITH CHECK ( public.can_access_tenant('casa_de_piedra') );

-- 2. Espacios CP
ALTER TABLE finanzas_casadepiedra.espacios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "cp_espacios_all" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "tenant_isolation_cdp_espacios" ON finanzas_casadepiedra.espacios;

CREATE POLICY "cp_espacios_all" ON finanzas_casadepiedra.espacios
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') )
WITH CHECK ( public.can_access_tenant('casa_de_piedra') );

-- 3. Clientes CP
ALTER TABLE finanzas_casadepiedra.clientes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "cp_clientes_all" ON finanzas_casadepiedra.clientes;
DROP POLICY IF EXISTS "tenant_isolation_cdp_clientes" ON finanzas_casadepiedra.clientes;

CREATE POLICY "cp_clientes_all" ON finanzas_casadepiedra.clientes
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') )
WITH CHECK ( public.can_access_tenant('casa_de_piedra') );


-- === RECARGA FINAL ===
NOTIFY pgrst, 'reload config';