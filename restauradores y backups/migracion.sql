-- Actualizaciones para el cotizador B2B de Casa de Piedra

-- 1. Agrega la columna de etiquetas (si no la tenía)
ALTER TABLE finanzas_casadepiedra.espacios 
ADD COLUMN IF NOT EXISTS etiquetas JSONB DEFAULT '[]'::jsonb;

-- 2. Agrega la matriz de logística B2B
ALTER TABLE finanzas_casadepiedra.espacios 
ADD COLUMN IF NOT EXISTS config_b2b JSONB DEFAULT '{"precio_montaje": 0, "precio_hora_extra": 0, "horarios": {"matutino": 0, "vespertino": 0, "nocturno": 0, "todo_dia": 0}}'::jsonb;

-- 3. Agrega la columna de detalles en las cotizaciones para guardar lo que elige el cliente
ALTER TABLE finanzas_casadepiedra.cotizaciones 
ADD COLUMN IF NOT EXISTS detalles_evento JSONB DEFAULT '{}'::jsonb;