-- 1. Apagar seguridad en la tabla principal
ALTER TABLE finanzas.cotizaciones DISABLE ROW LEVEL SECURITY;

-- 2. Asegurar permisos de lectura explícitos
GRANT ALL ON SCHEMA finanzas TO authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA finanzas TO authenticated;