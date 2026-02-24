-- 1. Asegurarnos de que las columnas B2B existan en tu Local
ALTER TABLE finanzas_casadepiedra.espacios ADD COLUMN IF NOT EXISTS config_b2b JSONB DEFAULT '{}'::jsonb;
ALTER TABLE finanzas_casadepiedra.espacios ADD COLUMN IF NOT EXISTS ajuste_tipo TEXT DEFAULT 'ninguno';
ALTER TABLE finanzas_casadepiedra.espacios ADD COLUMN IF NOT EXISTS ajuste_porcentaje NUMERIC DEFAULT 0;
ALTER TABLE finanzas_casadepiedra.espacios ADD COLUMN IF NOT EXISTS impuestos_ids JSONB DEFAULT '[]'::jsonb;

-- 2. El comando mágico para forzar a la API a recargar su mapa de tablas (Limpiar Caché)
NOTIFY pgrst, 'reload schema';