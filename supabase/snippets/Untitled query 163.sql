-- 1. Resetear seguridad en profiles
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- 2. Eliminar políticas viejas que causan conflicto
DROP POLICY IF EXISTS "profiles_policy_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_policy_insert" ON public.profiles;
DROP POLICY IF EXISTS "profiles_policy_update" ON public.profiles;
DROP POLICY IF EXISTS "profiles_recovery_select" ON public.profiles;
DROP POLICY IF EXISTS "profiles_read_policy" ON public.profiles;

-- 3. Crear Políticas SIN RECURSIÓN

-- Lectura: Puedo leer SI es mi ID O SI soy admin (usando la función segura)
CREATE POLICY "profiles_safe_select" ON public.profiles
FOR SELECT TO authenticated
USING ( id = auth.uid() OR public.is_admin() );

-- Escritura: Solo Admin o el propio usuario
CREATE POLICY "profiles_safe_update" ON public.profiles
FOR UPDATE TO authenticated
USING ( id = auth.uid() OR public.is_admin() );

CREATE POLICY "profiles_safe_insert" ON public.profiles
FOR INSERT TO authenticated
WITH CHECK ( id = auth.uid() );

-- 4. Reactivar seguridad
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;