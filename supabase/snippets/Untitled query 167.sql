CREATE OR REPLACE FUNCTION public.can_access_tenant(p_tenant text)
RETURNS boolean AS $$
DECLARE
    my_role text;
    my_tenant text;
    my_allowed_tenants text[];
    clean_my_tenant text;
    clean_request text;
BEGIN
    -- 1. Obtener datos del perfil del usuario
    SELECT role, tenant, allowed_tenants 
    INTO my_role, my_tenant, my_allowed_tenants
    FROM public.profiles
    WHERE id = auth.uid();

    -- 2. Si es ADMIN, pase usted
    IF my_role = 'admin' THEN
        RETURN true;
    END IF;

    -- 3. SI EL TENANT ES NULO, BLOQUEAR
    -- (Esto explica por qué tu usuario no entra si no se le ha asignado tenant)
    IF my_tenant IS NULL THEN
        RETURN false;
    END IF;

    -- 4. LIMPIEZA TOTAL (Normalización agresiva)
    -- Quitamos espacios y guiones bajos, y pasamos a minúsculas.
    -- Así "Plaza Mayor", "plaza_mayor" y "plaza mayor" se convierten en "plazamayor"
    clean_request := lower(replace(replace(p_tenant, ' ', ''), '_', ''));
    clean_my_tenant := lower(replace(replace(my_tenant, ' ', ''), '_', ''));

    -- 5. COMPARACIÓN
    IF clean_my_tenant = clean_request THEN
        RETURN true;
    END IF;

    -- 6. VERIFICAR ARRAY DE PERMISOS EXTRA
    IF my_allowed_tenants IS NOT NULL THEN
        -- Revisamos si alguno del array coincide (limpiando también los del array si es necesario)
        -- Para simplificar, asumimos búsqueda directa o parcial
        IF p_tenant = ANY(my_allowed_tenants) THEN
            RETURN true;
        END IF;
    END IF;

    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;