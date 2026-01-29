-- 1. FUNCIÓN AUXILIAR PARA ROMPER RECURSIÓN
-- Esta función verifica si eres admin saltándose las reglas RLS
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.profiles 
    WHERE id = auth.uid() 
    AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER; -- <--- ESTO ES LA CLAVE

-- 2. FUNCIÓN DE ACCESO A TENANT (Blindada)
CREATE OR REPLACE FUNCTION public.can_access_tenant(p_tenant text)
RETURNS boolean AS $$
DECLARE
    my_role text;
    my_tenant text;
    clean_req text;
    clean_my text;
BEGIN
    -- Obtenemos datos saltándonos RLS
    SELECT role, tenant INTO my_role, my_tenant
    FROM public.profiles
    WHERE id = auth.uid();

    -- Regla 1: Admin Total
    IF my_role = 'admin' THEN RETURN true; END IF;
    
    -- Regla 2: Sin tenant no hay acceso
    IF my_tenant IS NULL THEN RETURN false; END IF;

    -- Regla 3: Comparación Limpia (Normalización)
    clean_req := lower(replace(replace(COALESCE(p_tenant, ''), ' ', ''), '_', ''));
    clean_my := lower(replace(replace(COALESCE(my_tenant, ''), ' ', ''), '_', ''));

    IF clean_my = clean_req THEN RETURN true; END IF;

    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;