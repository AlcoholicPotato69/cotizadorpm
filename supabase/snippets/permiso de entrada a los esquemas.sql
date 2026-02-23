-- 1. Dar permiso de "entrada" a los esquemas
GRANT USAGE ON SCHEMA finanzas TO anon, authenticated;
GRANT USAGE ON SCHEMA finanzas_casadepiedra TO anon, authenticated;

-- 2. Dar permiso base sobre las tablas (Tus reglas RLS se encargarán de filtrar los datos después)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finanzas TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finanzas_casadepiedra TO anon, authenticated;

-- 3. Dar permiso para que puedan crear nuevos registros con IDs automáticos (secuencias)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas TO anon, authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finanzas_casadepiedra TO anon, authenticated;

-- 4. Dar permiso para ejecutar funciones dentro de esos esquemas
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA finanzas TO anon, authenticated;
GRANT EXECUTE ON ALL ROUTINES IN SCHEMA finanzas_casadepiedra TO anon, authenticated;

-- 5. (Opcional pero recomendado) Hacer que cualquier tabla futura herede estos permisos automáticamente
ALTER DEFAULT PRIVILEGES IN SCHEMA finanzas GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA finanzas_casadepiedra GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO anon, authenticated;