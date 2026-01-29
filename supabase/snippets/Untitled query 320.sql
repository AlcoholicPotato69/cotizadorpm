-- =================================================================
-- LIMPIEZA Y OPTIMIZACIÓN DE RLS (TABLA PROFILES)
-- =================================================================

-- 1. ELIMINAR POLÍTICAS DUPLICADAS O VIEJAS
-- Borramos tanto las genéricas como las específicas para limpiar el conflicto
DROP POLICY IF EXISTS "profiles_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_self" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;

-- 2. CREAR POLÍTICAS UNIFICADAS Y OPTIMIZADAS
-- Usamos (select auth.uid()) para corregir el warning 'auth_rls_initplan'

-- A. SELECT (Lectura)
-- Permite ver el perfil si: Es tuyo O Eres Admin/Staff (Staff ve todo)
CREATE POLICY "profiles_unified_select" ON public.profiles
FOR SELECT TO authenticated
USING (
  id = (select auth.uid()) -- Es mi perfil
  OR
  EXISTS ( -- O soy parte del staff/admin (Verificación optimizada)
    SELECT 1 FROM public.profiles
    WHERE id = (select auth.uid())
    AND role IN ('admin', 'staff', 'manager') -- Ajusta roles según tu app
  )
);

-- B. INSERT (Creación)
-- Permite crear perfil solo si el ID coincide con tu usuario Auth
CREATE POLICY "profiles_unified_insert" ON public.profiles
FOR INSERT TO authenticated
WITH CHECK (
  id = (select auth.uid())
);

-- C. UPDATE (Edición)
-- Permite editar si: Es tu perfil O Eres Admin (El Staff usualmente no edita perfiles ajenos)
CREATE POLICY "profiles_unified_update" ON public.profiles
FOR UPDATE TO authenticated
USING (
  id = (select auth.uid())
  OR
  EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = (select auth.uid())
    AND role = 'admin'
  )
);

-- NOTA: No tocamos DELETE porque no aparecía en los warnings, 
-- pero si existiera duplicidad, la lógica sería similar.