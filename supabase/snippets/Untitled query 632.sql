-- =================================================================
-- MIGRACIÓN TOTAL A SISTEMA DE ROLES (Admin, Plaza Mayor, Casa de Piedra)
-- =================================================================

-- 1. MIGRACIÓN DE DATOS (Convertir Tenants a Roles)
-- -----------------------------------------------------------------
UPDATE public.profiles
SET role = 'plaza_mayor'
WHERE role = 'user' AND (tenant ILIKE '%plaza%' OR tenant IS NULL); 

UPDATE public.profiles
SET role = 'casa_de_piedra'
WHERE role = 'user' AND tenant ILIKE '%casa%';

-- 2. LIMPIEZA PROFUNDA (La solución a tu error)
-- -----------------------------------------------------------------
-- CASCADE borrará la función Y todas las políticas viejas que daban error.
DROP FUNCTION IF EXISTS public.can_access_tenant(text) CASCADE;

-- 3. NUEVA FUNCIÓN DE SEGURIDAD (Simple y Rápida)
-- -----------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS text AS $$
DECLARE
  current_role text;
BEGIN
  -- Obtenemos el rol directo del perfil
  SELECT role INTO current_role
  FROM public.profiles
  WHERE id = auth.uid();
  
  RETURN current_role;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = public, auth, extensions;

-- 4. SEGURIDAD EN PERFILES (PROFILES)
-- -----------------------------------------------------------------
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "profiles_safe_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_safe_update" ON public.profiles;
DROP POLICY IF EXISTS "profiles_safe_insert" ON public.profiles;
DROP POLICY IF EXISTS "read_own_profile" ON public.profiles;
DROP POLICY IF EXISTS "update_own_profile" ON public.profiles;

-- Lectura: Cada quien ve lo suyo
CREATE POLICY "read_own_profile" ON public.profiles
FOR SELECT TO authenticated USING ( id = auth.uid() );

-- Escritura: Admin o el propio usuario
CREATE POLICY "update_own_profile" ON public.profiles
FOR UPDATE TO authenticated
USING ( id = auth.uid() OR (SELECT role FROM public.profiles WHERE id = auth.uid()) = 'admin' );

CREATE POLICY "insert_own_profile" ON public.profiles
FOR INSERT TO authenticated WITH CHECK ( id = auth.uid() );

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- 5. REGLAS PARA PLAZA MAYOR (Esquema: finanzas)
-- -----------------------------------------------------------------
-- Cotizaciones
ALTER TABLE finanzas.cotizaciones ENABLE ROW LEVEL SECURITY;
-- (No necesitamos borrar las viejas políticas manualmente, CASCADE ya lo hizo arriba)
CREATE POLICY "access_pm_cotizaciones" ON finanzas.cotizaciones
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'plaza_mayor') );

-- Espacios
ALTER TABLE finanzas.espacios ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_pm_espacios" ON finanzas.espacios
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'plaza_mayor') );

-- Clientes
ALTER TABLE finanzas.clientes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_pm_clientes" ON finanzas.clientes
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'plaza_mayor') );

-- Conceptos e Impuestos
ALTER TABLE finanzas.conceptos_catalogo ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_pm_conceptos" ON finanzas.conceptos_catalogo
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'plaza_mayor') );

ALTER TABLE finanzas.impuestos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_pm_impuestos" ON finanzas.impuestos
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'plaza_mayor') );

-- 6. REGLAS PARA CASA DE PIEDRA (Esquema: finanzas_casadepiedra)
-- -----------------------------------------------------------------
-- Cotizaciones CP
ALTER TABLE finanzas_casadepiedra.cotizaciones ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_cdp_cotizaciones" ON finanzas_casadepiedra.cotizaciones
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'casa_de_piedra') );

-- Espacios CP
ALTER TABLE finanzas_casadepiedra.espacios ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_cdp_espacios" ON finanzas_casadepiedra.espacios
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'casa_de_piedra') );

-- Clientes CP
ALTER TABLE finanzas_casadepiedra.clientes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "access_cdp_clientes" ON finanzas_casadepiedra.clientes
FOR ALL TO authenticated
USING ( public.get_my_role() IN ('admin', 'casa_de_piedra') );

-- 7. RECARGA FINAL
-- -----------------------------------------------------------------
NOTIFY pgrst, 'reload config';