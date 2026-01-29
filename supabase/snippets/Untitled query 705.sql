-- =================================================================
-- 1. OPTIMIZACIÓN DE PERFILES (public.profiles)
-- Soluciona: auth_rls_initplan y multiple_permissive_policies
-- =================================================================

-- Primero, limpiamos TODAS las políticas viejas o duplicadas en profiles
DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
DROP POLICY IF EXISTS "allow_read_own_profile" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_own_or_admin" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own_or_admin" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_self" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update" ON public.profiles;

-- Creamos las 3 Políticas Maestras Optimizadas (usando select auth.uid())

-- A. LECTURA (SELECT): Ver mi perfil O ver todos si soy admin
CREATE POLICY "profiles_policy_select" ON public.profiles
FOR SELECT TO authenticated
USING (
  id = (select auth.uid()) -- Optimización de rendimiento
  OR
  (select role from public.profiles where id = (select auth.uid())) = 'admin'
);

-- B. ACTUALIZACIÓN (UPDATE): Editar mi perfil O editar cualquiera si soy admin
CREATE POLICY "profiles_policy_update" ON public.profiles
FOR UPDATE TO authenticated
USING (
  id = (select auth.uid()) 
  OR 
  (select role from public.profiles where id = (select auth.uid())) = 'admin'
);

-- C. CREACIÓN (INSERT): Permitir al usuario crear su propio perfil al registrarse
CREATE POLICY "profiles_policy_insert" ON public.profiles
FOR INSERT TO authenticated
WITH CHECK (
  id = (select auth.uid())
);


-- =================================================================
-- 2. LIMPIEZA ESQUEMA FINANZAS (Plaza Mayor)
-- Soluciona: multiple_permissive_policies (Conflictos entre reglas viejas y nuevas)
-- =================================================================

-- Limpieza de COTIZACIONES
DROP POLICY IF EXISTS "pm_cotizaciones_select" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "pm_cotizaciones_write" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "pm_cotizaciones_update" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "pm_cotizaciones_delete" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "tenant_select" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "tenant_update" ON finanzas.cotizaciones;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas.cotizaciones;
-- Mantenemos (o recreamos) SOLO la regla maestra unificada
DROP POLICY IF EXISTS "tenant_isolation_pm" ON finanzas.cotizaciones;
CREATE POLICY "tenant_isolation_pm" ON finanzas.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') );

-- Limpieza de CLIENTES
DROP POLICY IF EXISTS "allow authenticated full access" ON finanzas.clientes;
DROP POLICY IF EXISTS "pm_clientes_select" ON finanzas.clientes;
DROP POLICY IF EXISTS "pm_clientes_write" ON finanzas.clientes;
DROP POLICY IF EXISTS "pm_clientes_update" ON finanzas.clientes;
DROP POLICY IF EXISTS "pm_clientes_delete" ON finanzas.clientes;
-- Regla Maestra
CREATE POLICY "tenant_isolation_pm_clientes" ON finanzas.clientes
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') );

-- Limpieza de ESPACIOS
DROP POLICY IF EXISTS "pm_espacios_select" ON finanzas.espacios;
DROP POLICY IF EXISTS "pm_espacios_write" ON finanzas.espacios;
DROP POLICY IF EXISTS "pm_espacios_update" ON finanzas.espacios;
DROP POLICY IF EXISTS "pm_espacios_delete" ON finanzas.espacios;
DROP POLICY IF EXISTS "tenant_select" ON finanzas.espacios;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas.espacios;
DROP POLICY IF EXISTS "tenant_update" ON finanzas.espacios;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas.espacios;
-- Regla Maestra
DROP POLICY IF EXISTS "tenant_isolation_pm_espacios" ON finanzas.espacios;
CREATE POLICY "tenant_isolation_pm_espacios" ON finanzas.espacios
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') );

-- Limpieza de IMPUESTOS
DROP POLICY IF EXISTS "pm_cfg_impuestos_select" ON finanzas.impuestos;
DROP POLICY IF EXISTS "pm_cfg_impuestos_admin_write" ON finanzas.impuestos;
DROP POLICY IF EXISTS "tenant_select" ON finanzas.impuestos;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas.impuestos;
DROP POLICY IF EXISTS "tenant_update" ON finanzas.impuestos;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas.impuestos;
-- Regla Maestra
CREATE POLICY "tenant_isolation_pm_impuestos" ON finanzas.impuestos
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') );

-- Limpieza de CONCEPTOS
DROP POLICY IF EXISTS "pm_cfg_conceptos_catalogo_select" ON finanzas.conceptos_catalogo;
DROP POLICY IF EXISTS "pm_cfg_conceptos_catalogo_admin_write" ON finanzas.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_select" ON finanzas.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_update" ON finanzas.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas.conceptos_catalogo;
-- Regla Maestra
DROP POLICY IF EXISTS "tenant_isolation_pm_conceptos" ON finanzas.conceptos_catalogo;
CREATE POLICY "tenant_isolation_pm_conceptos" ON finanzas.conceptos_catalogo
FOR ALL TO authenticated
USING ( public.can_access_tenant('plaza_mayor') );


-- =================================================================
-- 3. LIMPIEZA ESQUEMA CASA DE PIEDRA
-- Soluciona: multiple_permissive_policies
-- =================================================================

-- Limpieza COTIZACIONES
DROP POLICY IF EXISTS "cp_cotizaciones_select" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "cp_cotizaciones_write" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "cp_cotizaciones_update" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "cp_cotizaciones_delete" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "tenant_select" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "tenant_update" ON finanzas_casadepiedra.cotizaciones;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas_casadepiedra.cotizaciones;
-- Regla Maestra
DROP POLICY IF EXISTS "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones;
CREATE POLICY "tenant_isolation_cdp" ON finanzas_casadepiedra.cotizaciones
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') );

-- Limpieza CLIENTES
DROP POLICY IF EXISTS "allow authenticated full access" ON finanzas_casadepiedra.clientes;
DROP POLICY IF EXISTS "cp_clientes_select" ON finanzas_casadepiedra.clientes;
DROP POLICY IF EXISTS "cp_clientes_write" ON finanzas_casadepiedra.clientes;
DROP POLICY IF EXISTS "cp_clientes_update" ON finanzas_casadepiedra.clientes;
DROP POLICY IF EXISTS "cp_clientes_delete" ON finanzas_casadepiedra.clientes;
-- Regla Maestra
CREATE POLICY "tenant_isolation_cdp_clientes" ON finanzas_casadepiedra.clientes
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') );

-- Limpieza ESPACIOS
DROP POLICY IF EXISTS "cp_espacios_select" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "cp_espacios_write" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "cp_espacios_update" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "cp_espacios_delete" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "tenant_select" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "tenant_update" ON finanzas_casadepiedra.espacios;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas_casadepiedra.espacios;
-- Regla Maestra
DROP POLICY IF EXISTS "tenant_isolation_cdp_espacios" ON finanzas_casadepiedra.espacios;
CREATE POLICY "tenant_isolation_cdp_espacios" ON finanzas_casadepiedra.espacios
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') );

-- Limpieza IMPUESTOS
DROP POLICY IF EXISTS "cp_cfg_impuestos_select" ON finanzas_casadepiedra.impuestos;
DROP POLICY IF EXISTS "cp_cfg_impuestos_admin_write" ON finanzas_casadepiedra.impuestos;
DROP POLICY IF EXISTS "tenant_select" ON finanzas_casadepiedra.impuestos;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas_casadepiedra.impuestos;
DROP POLICY IF EXISTS "tenant_update" ON finanzas_casadepiedra.impuestos;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas_casadepiedra.impuestos;
-- Regla Maestra
CREATE POLICY "tenant_isolation_cdp_impuestos" ON finanzas_casadepiedra.impuestos
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') );

-- Limpieza CONCEPTOS
DROP POLICY IF EXISTS "cp_cfg_conceptos_catalogo_select" ON finanzas_casadepiedra.conceptos_catalogo;
DROP POLICY IF EXISTS "cp_cfg_conceptos_catalogo_admin_write" ON finanzas_casadepiedra.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_select" ON finanzas_casadepiedra.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_insert" ON finanzas_casadepiedra.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_update" ON finanzas_casadepiedra.conceptos_catalogo;
DROP POLICY IF EXISTS "tenant_delete" ON finanzas_casadepiedra.conceptos_catalogo;
-- Regla Maestra
DROP POLICY IF EXISTS "tenant_isolation_cdp_conceptos" ON finanzas_casadepiedra.conceptos_catalogo;
CREATE POLICY "tenant_isolation_cdp_conceptos" ON finanzas_casadepiedra.conceptos_catalogo
FOR ALL TO authenticated
USING ( public.can_access_tenant('casa_de_piedra') );

NOTIFY pgrst, 'reload config';