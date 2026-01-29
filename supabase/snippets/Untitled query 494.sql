-- =================================================================
-- SCRIPT DE EMERGENCIA: RESTAURACIÓN DE ACCESO TOTAL
-- =================================================================

-- 1. DESBLOQUEAR LA TABLA DE PERFILES (CRÍTICO)
-- Si esto falla, el front-end se queda en blanco porque no sabe el rol.
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY; -- Apagamos momentáneamente para resetear
DROP POLICY IF EXISTS "profiles_policy_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_unified_select" ON public.profiles;

-- Creamos una política de lectura INFALIBLE
CREATE POLICY "profiles_recovery_select" ON public.profiles
FOR SELECT TO authenticated
USING (
  -- O es mi perfil, O soy admin, O es un Service Role (interno)
  auth.uid() = id 
  OR 
  (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin'
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY; -- Encendemos de nuevo

-- 2. REPARAR LA FUNCIÓN MAESTRA DE SEGURIDAD
-- Aseguramos search_path y prioridad al Admin.
CREATE OR REPLACE FUNCTION public.can_access_tenant(p_tenant text)
RETURNS boolean AS $$
DECLARE
    my_role text;
    my_tenant text;
    my_allowed text[];
    clean_req text;
    clean_my text;
BEGIN
    -- Obtener datos blindados
    SELECT role, tenant, allowed_tenants 
    INTO my_role, my_tenant, my_allowed
    FROM public.profiles
    WHERE id = auth.uid();

    -- REGLA DE ORO: SI ES ADMIN, TRUE INMEDIATO (Sin importar nulos ni textos)
    IF my_role = 'admin' THEN
        RETURN true;
    END IF;

    -- Si no es admin y no tiene tenant, fuera.
    IF my_tenant IS NULL THEN
        RETURN false;
    END IF;

    -- Limpieza de texto para comparación
    clean_req := lower(replace(replace(COALESCE(p_tenant, ''), ' ', ''), '_', ''));
    clean_my := lower(replace(replace(COALESCE(my_tenant, ''), ' ', ''), '_', ''));

    -- Comparación
    IF clean_my = clean_req THEN RETURN true; END IF;

    -- Array extra
    IF my_allowed IS NOT NULL THEN
       IF p_tenant = ANY(my_allowed) THEN RETURN true; END IF;
    END IF;

    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER 
SET search_path = public, auth, extensions; -- Importante para que no falle

-- 3. REAPLICAR PERMISOS A LAS TABLAS (Finanzas)
-- Aseguramos que la política use la función reparada

-- Cotizaciones
DROP POLICY IF EXISTS "tenant_isolation_pm" ON finanzas.cotizaciones;
CREATE POLICY "tenant_isolation_pm" ON finanzas.cotizaciones
FOR ALL TO authenticated USING ( public.can_access_tenant('plaza_mayor') );

-- Espacios
DROP POLICY IF EXISTS "tenant_isolation_pm_espacios" ON finanzas.espacios;
CREATE POLICY "tenant_isolation_pm_espacios" ON finanzas.espacios
FOR ALL TO authenticated USING ( public.can_access_tenant('plaza_mayor') );

-- Clientes
DROP POLICY IF EXISTS "tenant_isolation_pm_clientes" ON finanzas.clientes;
CREATE POLICY "tenant_isolation_pm_clientes" ON finanzas.clientes
FOR ALL TO authenticated USING ( public.can_access_tenant('plaza_mayor') );

-- 4. REAPLICAR PERMISOS A LAS TABLAS (Casa de Piedra)

-- Cotizaciones CP
DROP POLICY IF EXISTS "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones;
CREATE POLICY "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones
FOR ALL TO authenticated USING ( public.can_access_tenant('casa_de_piedra') );

-- Espacios CP
DROP POLICY IF EXISTS "tenant_isolation_cdp_espacios" ON finanzas_casadepiedra.espacios;
CREATE POLICY "tenant_isolation_cdp_espacios" ON finanzas_casadepiedra.espacios
FOR ALL TO authenticated USING ( public.can_access_tenant('casa_de_piedra') );


-- 5. FORZAR RECARGA
NOTIFY pgrst, 'reload config';