-- ============================================================================
-- SCRIPT DE ESCANEO DE ESTRUCTURA (RADIOGRAFÍA DE LA BASE DE DATOS)
-- Genera un reporte legible de Tablas, Columnas, Políticas RLS y Funciones.
-- ============================================================================

WITH 
-- 1. Obtener Tablas y Columnas
structure_info AS (
    SELECT 
        1 as priority,
        'TABLA: ' || table_schema || '.' || table_name as info,
        'Columnas: ' || string_agg(column_name || ' (' || data_type || ')', ', ') as details
    FROM information_schema.columns
    WHERE table_schema NOT IN ('information_schema', 'pg_catalog', 'auth', 'storage', 'graphql', 'graphql_public', 'realtime', 'vault', 'pgsodium', 'pg_toast')
    GROUP BY table_schema, table_name
),

-- 2. Obtener Políticas de Seguridad (RLS)
policy_info AS (
    SELECT 
        2 as priority,
        'RLS: ' || schemaname || '.' || tablename as info,
        'Politica: "' || policyname || '" | Acción: ' || cmd || ' | Roles: ' || array_to_string(roles, ',') || ' | USING: ' ||  coalesce(qual::text, 'N/A') || ' | CHECK: ' || coalesce(with_check::text, 'N/A') as details
    FROM pg_policies
    WHERE schemaname NOT IN ('auth', 'storage')
),

-- 3. Obtener Funciones Personalizadas (Importante para tu multi-tenant)
function_info AS (
    SELECT 
        3 as priority,
        'FUNCION: ' || n.nspname || '.' || p.proname as info,
        'Argumentos: ' || pg_get_function_arguments(p.oid) || ' | Retorno: ' || pg_get_function_result(p.oid) as details
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname NOT IN ('information_schema', 'pg_catalog', 'auth', 'storage', 'graphql', 'graphql_public', 'realtime', 'vault', 'pgsodium')
    AND p.proname NOT LIKE 'pg_%'
)

-- 4. Unir todo en un reporte ordenado
SELECT info, details 
FROM (
    SELECT * FROM structure_info
    UNION ALL
    SELECT * FROM policy_info
    UNION ALL
    SELECT * FROM function_info
) combined_data
ORDER BY priority, info;