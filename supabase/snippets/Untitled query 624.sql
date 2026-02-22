-- =================================================================================
-- 1. CORRECCIÓN DE ESPACIOS EN CASA DE PIEDRA (finanzas_casadepiedra.espacios)
-- =================================================================================

-- ID 4: Jardín Principal
UPDATE finanzas_casadepiedra.espacios SET 
descripcion = 'Un espacio abierto, rodeado de la icónica arquitectura de la Ex-Hacienda aunado de una increíble vegetación. Cuenta con capacidad máxima para 1500 personas, es el único recinto en la ciudad de León que permite albergar a este gran número de comensales. El jardín de Casa de Piedra es el escenario perfecto para realizar eventos al aire libre en donde la naturaleza interviene como uno de los principales elementos para brindarte un ambiente encantador.' || E'\n\n' || 'Ubicación: Por definir.' || E'\n' || 'Materiales: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Jardín", "Al aire libre", "Gran Formato"]'::jsonb 
WHERE id = 4;

-- ID 2: Salón Pavoreales
UPDATE finanzas_casadepiedra.espacios SET 
descripcion = 'Un salón privado, que pareciera una hermosa réplica de nuestro salón principal, con ambientación delicada y elegante y la privacidad necesaria para reuniones sociales o empresariales. Cuenta con una capacidad para 70 personas en un evento empresarial, y con un montaje estilo auditorio, la capacidad incrementa para 100 personas.' || E'\n\n' || 'Ubicación: Por definir.' || E'\n' || 'Materiales: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Salón", "Privado", "Empresarial"]'::jsonb 
WHERE id = 2;

-- ID 1: Salón Principal
UPDATE finanzas_casadepiedra.espacios SET 
descripcion = 'Un espacio privado y agradable, techado, con gran iluminación y delimitado por elegantes muros apanelados, con capacidad para 1000 personas, se convierte en el escenario perfecto para eventos como bodas, xv años, conferencias y eventos corporativos.' || E'\n\n' || 'Ubicación: Por definir.' || E'\n' || 'Materiales: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Salón", "Gran Formato", "Techado"]'::jsonb 
WHERE id = 1;

-- ID 3: Terraza del Mezquite
UPDATE finanzas_casadepiedra.espacios SET 
descripcion = 'Al aire libre y enmarcada por hermosos arcos coloniales y fuentes minimalistas que ofrecen un ambiente de relajación y vistas elegantes y acogedoras. Con una capacidad para 200 personas, este lugar es el espacio ideal para eventos como despedidas de soltera, fiestas de cumpleaños, primeras comuniones, bautizos, fiestas infantiles y reuniones corporativas.' || E'\n\n' || 'Ubicación: Por definir.' || E'\n' || 'Materiales: Por definir.' || E'\n' || 'Medidas: Por definir.', 
etiquetas = '["Terraza", "Al aire libre", "Social"]'::jsonb 
WHERE id = 3;


-- =================================================================================
-- 2. CORRECCIÓN DE CONCEPTOS DE CATÁLOGO (Ambos Esquemas)
-- =================================================================================

-- Casa de Piedra
UPDATE finanzas_casadepiedra.conceptos_catalogo 
SET nombre = 'Generador de energía' 
WHERE id = 4;

-- Plaza Mayor
UPDATE finanzas.conceptos_catalogo 
SET nombre = 'Modificación manual' 
WHERE id = 2;

UPDATE finanzas.conceptos_catalogo 
SET nombre = 'Instalación' 
WHERE id = 5;