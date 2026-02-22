-- Reparación de la tabla espacios: Ortografía, Estructura (Ubicación, Material, Medidas) y Etiquetas

-- ID 6
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Entre Banamex y Sanborns de cara al pórtico 1.' || E'\n' || 'Material: Lona.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Puente", "Aéreo", "Lona"]'::jsonb 
WHERE id = 6;

-- ID 7
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 1 en el acceso a zona 3, a un costado de Coloso y Zara.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Muro", "Pasillo"]'::jsonb 
WHERE id = 7;

-- ID 8
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Debajo del domo principal en zona 1.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Aéreo", "Domo"]'::jsonb 
WHERE id = 8;

-- ID 9
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 3, frente a Sears, de cara al domo principal.' || E'\n' || 'Material: Vinil sobre bastidor.' || E'\n' || 'Medidas: 13.0m x 3.0m.', 
etiquetas = '["Muro", "Espectacular", "Pasillo", "Vinil"]'::jsonb 
WHERE id = 9;

-- ID 10
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En el pasillo de salida de zona 2 y entrada a zona 1 por la pista de hielo.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Antepecho", "Pasillo"]'::jsonb 
WHERE id = 10;

-- ID 11
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 3, frente a Sears, Zara, Liverpool y la isla de Starbucks.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Escaleras", "Domo"]'::jsonb 
WHERE id = 11;

-- ID 12
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En los principales pasillos de zona 3, visibles desde primer y segundo piso.' || E'\n' || 'Material: Lona.' || E'\n' || 'Medidas: 70cm x 500cm.', 
etiquetas = '["Pendones", "Paquete", "Aéreo", "Lona"]'::jsonb 
WHERE id = 12;

-- ID 13
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Pasillo principal de zona 3, visible desde primer y segundo piso.' || E'\n' || 'Material: Lona sobre bastidor.' || E'\n' || 'Medidas: 7.28m x 1.19m.', 
etiquetas = '["Puente", "Aéreo", "Pasillo", "Lona"]'::jsonb 
WHERE id = 13;

-- ID 14
UPDATE finanzas.espacios SET 
nombre = 'Espectacular sobre balcón Sears',
descripcion = 'Ubicación: En zona 1, entre Zara y Massimo Dutti, con vista al pórtico 1.' || E'\n' || 'Material: Lona sobre bastidor.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Espectacular", "Aéreo", "Lona"]'::jsonb 
WHERE id = 14;

-- ID 15
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Debajo del domo principal en zona 3.' || E'\n' || 'Material: Lona sobre bastidor.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Aéreo", "Domo", "Lona"]'::jsonb 
WHERE id = 15;

-- ID 16
UPDATE finanzas.espacios SET 
nombre = 'Cristales interiores de escaleras eléctricas',
descripcion = 'Ubicación: En zona 4, frente al acceso del pórtico 4 y acceso a planta hacia Cinemex.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Cristal", "Escaleras", "Vinil"]'::jsonb 
WHERE id = 16;

-- ID 17
UPDATE finanzas.espacios SET 
nombre = 'Cristales exteriores de escaleras eléctricas',
descripcion = 'Ubicación: En zona 4, frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: 2.77m x 3.65m.', 
etiquetas = '["Cristal", "Escaleras", "Vinil"]'::jsonb 
WHERE id = 17;

-- ID 18
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 6, frente a H&M de cara a explanada de fuente y diversas islas.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Cristal", "Muro"]'::jsonb 
WHERE id = 18;

-- ID 19
UPDATE finanzas.espacios SET 
nombre = 'Elevador panorámico',
descripcion = 'Ubicación: En zona 5 frente al acceso del pórtico 4 y acceso a segunda planta hacia Cinemex.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: 2.14m x 9.77m.', 
etiquetas = '["Elevador", "Vinil"]'::jsonb 
WHERE id = 19;

-- ID 20
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Zona 6 en el pasillo principal frente a Banana Republic, Stradivarius, etc.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Cristal", "Escaleras", "Pasillo", "Vinil"]'::jsonb 
WHERE id = 20;

-- ID 21
UPDATE finanzas.espacios SET 
nombre = 'Cristales exteriores de escaleras eléctricas',
descripcion = 'Ubicación: En zona 4 frente a Zara home en el centro de Zona Moda.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: 2.77m x 3.65m.', 
etiquetas = '["Cristal", "Escaleras", "Vinil"]'::jsonb 
WHERE id = 21;

-- ID 22
UPDATE finanzas.espacios SET 
nombre = 'Cristal exterior de escaleras eléctricas',
descripcion = 'Ubicación: En zona 4 frente a H&M en el acceso a Zona Moda.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Cristal", "Escaleras", "Vinil"]'::jsonb 
WHERE id = 22;

-- ID 23
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 6 frente a H&M y Vans, de cara a zona de cajeros.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Puente", "Aéreo", "Pasillo", "Vinil"]'::jsonb 
WHERE id = 23;

-- ID 24
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 6, frente a H&M y Vans de cara a escaleras eléctricas.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Puente", "Aéreo", "Pasillo", "Vinil"]'::jsonb 
WHERE id = 24;

-- ID 25
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: En zona 6 a la salida del subterráneo, de cara al pasillo principal.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Elevador", "Subterráneo", "Pasillo", "Vinil"]'::jsonb 
WHERE id = 25;

-- ID 26
UPDATE finanzas.espacios SET 
nombre = 'Escaleras eléctricas subterráneo Liverpool (2 caras)',
descripcion = 'Ubicación: En zona 7 a la salida del subterráneo que da a Liverpool y al foro de Zona Moda.' || E'\n' || 'Material: Vinil autoadherible.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Escaleras", "Subterráneo", "Vinil"]'::jsonb 
WHERE id = 26;

-- ID 27
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Variedad de zonas y tamaños en estacionamiento.' || E'\n' || 'Material: Lona en bastidor.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Estacionamiento", "Pendones", "Paquete", "Lona"]'::jsonb 
WHERE id = 27;

-- ID 28
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Variedad de salidas de estacionamiento.' || E'\n' || 'Material: Vinil.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Estacionamiento", "Paquete", "Vinil"]'::jsonb 
WHERE id = 28;

-- ID 32
UPDATE finanzas.espacios SET 
descripcion = 'Ubicación: Por definir.' || E'\n' || 'Material: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Prueba"]'::jsonb 
WHERE id = 32;