-- Para Plaza Mayor
CREATE POLICY "Anon_Ve_Espacios_PM" ON finanzas.espacios 
FOR SELECT TO anon USING (activo = 'TRUE');

-- Para Casa de Piedra
CREATE POLICY "Anon_Ve_Espacios_CP" ON finanzas_casadepiedra.espacios 
FOR SELECT TO anon USING (activo = 'TRUE');