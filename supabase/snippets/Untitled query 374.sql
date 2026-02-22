-- Permitir al público enviar cotizaciones
CREATE POLICY "Publico_Manda_Cotizaciones_PM" ON finanzas.cotizaciones FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Publico_Manda_Cotizaciones_CP" ON finanzas_casadepiedra.cotizaciones FOR INSERT TO anon WITH CHECK (true);

-- Permitir al público ver las fechas ya ocupadas en el calendario
CREATE POLICY "Publico_Ve_Fechas_PM" ON finanzas.cotizaciones FOR SELECT TO anon USING (status IN ('aprobada', 'finalizada'));
CREATE POLICY "Publico_Ve_Fechas_CP" ON finanzas_casadepiedra.cotizaciones FOR SELECT TO anon USING (status IN ('aprobada', 'finalizada'));