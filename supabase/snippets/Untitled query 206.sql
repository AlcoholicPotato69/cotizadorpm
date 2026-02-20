-- 1. Dar permiso al rol anónimo para usar el esquema finanzas
GRANT USAGE ON SCHEMA finanzas TO anon;

-- 2. Dar permiso de lectura en la tabla específica
GRANT SELECT ON finanzas.espacios TO anon;

-- 3. Crear la política (Aplica automáticamente el filtro)
DROP POLICY IF EXISTS "Publico_Ve_Espacios_Activos" ON finanzas.espacios;

CREATE POLICY "Publico_Ve_Espacios_Activos" 
ON finanzas.espacios 
FOR SELECT 
TO anon 
USING (activo = true);