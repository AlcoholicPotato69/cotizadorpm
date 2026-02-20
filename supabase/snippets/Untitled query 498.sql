-- Permitir al público insertar en la tabla de cotizaciones de Casa de Piedra
GRANT INSERT ON finanzas_casadepiedra.cotizaciones TO anon;

-- Crear la política que permite la inserción anónima
DROP POLICY IF EXISTS "Anon_Crea_Cotizaciones_CP" ON finanzas_casadepiedra.cotizaciones;
CREATE POLICY "Anon_Crea_Cotizaciones_CP" ON finanzas_casadepiedra.cotizaciones
FOR INSERT TO anon WITH CHECK (true);