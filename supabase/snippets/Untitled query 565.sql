-- Para el esquema finanzas (Plaza Mayor)
GRANT SELECT ON finanzas.cotizaciones TO anon;
CREATE POLICY "Anon_Ve_Fechas_Ocupadas_PM" ON finanzas.cotizaciones
FOR SELECT TO anon USING (status IN ('aprobada', 'finalizada'));

-- Para el esquema finanzas_casadepiedra (Casa de Piedra)
GRANT SELECT ON finanzas_casadepiedra.cotizaciones TO anon;
CREATE POLICY "Anon_Ve_Fechas_Ocupadas_CP" ON finanzas_casadepiedra.cotizaciones
FOR SELECT TO anon USING (status IN ('aprobada', 'finalizada'));