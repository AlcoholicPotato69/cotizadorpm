-- =================================================================
-- CORRECCIÓN DE SEGURIDAD: SEARCH_PATH MUTABLE
-- Blindamos las funciones para que solo miren en los esquemas seguros.
-- =================================================================

-- 1. Función set_updated_at (Trigger de actualización de fechas)
-- Le decimos que use 'public' y 'extensions' (por si usa funciones de tiempo)
ALTER FUNCTION public.set_updated_at() 
SET search_path = public, extensions;

-- 2. Función jwt_role (Obtiene el rol del usuario)
-- Esta función suele leer configuración, aseguramos el entorno 'public'
ALTER FUNCTION public.jwt_role() 
SET search_path = public, extensions;

-- 3. Función handle_new_user_profile (Crea el perfil al registrarse)
-- ESTA ES CRÍTICA. Interactúa con 'auth' (usuarios) y 'public' (perfiles).
-- Debemos darle acceso explícito a ambos esquemas.
ALTER FUNCTION public.handle_new_user_profile() 
SET search_path = public, auth, extensions;

-- 4. Forzamos recarga para que el PostgREST tome los cambios de seguridad
NOTIFY pgrst, 'reload config';