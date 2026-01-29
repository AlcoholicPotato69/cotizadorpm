-- =================================================================
-- REPARACIÓN DEL NÚCLEO DE SEGURIDAD (Corregido para p_tenant)
-- =================================================================

CREATE OR REPLACE FUNCTION public.can_access_tenant(p_tenant text) -- <--- Usamos el nombre original
RETURNS boolean AS $$
DECLARE
    my_role text;
    my_tenant text;
    my_allowed_tenants text[]; 
    normalized_my_tenant text;
    normalized_request text;
BEGIN
    -- 1. Obtener datos del usuario actual
    -- SECURITY DEFINER permite leer profiles aunque el usuario tenga restricciones
    SELECT 
        role, 
        tenant, 
        allowed_tenants 
    INTO 
        my_role, 
        my_tenant, 
        my_allowed_tenants
    FROM public.profiles
    WHERE id = auth.uid();

    -- 2. REGLA SUPREMA: Admin ve todo
    IF my_role = 'admin' THEN
        RETURN true;
    END IF;

    -- 3. NORMALIZACIÓN DE TEXTO
    -- Convierte "Plaza Mayor" -> "plaza_mayor" para evitar errores de escritura
    normalized_request := lower(p_tenant); -- Usamos el parámetro p_tenant
    normalized_my_tenant := lower(replace(my_tenant, ' ', '_')); 

    -- 4. COMPARACIÓN DIRECTA (Tenant Principal)
    IF normalized_my_tenant = normalized_request THEN
        RETURN true;
    END IF;

    -- 5. COMPARACIÓN SECUNDARIA (Array allowed_tenants)
    IF my_allowed_tenants IS NOT NULL THEN
        -- Verifica si p_tenant o su versión normalizada están en el array del usuario
        IF p_tenant = ANY(my_allowed_tenants) OR normalized_request = ANY(my_allowed_tenants) THEN
            RETURN true;
        END IF;
    END IF;

    -- Si nada coincide, denegar acceso
    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Forzar recarga de configuración para asegurar que los cambios se apliquen
NOTIFY pgrst, 'reload config';