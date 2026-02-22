ALTER TABLE finanzas_casadepiedra.cotizaciones 
ADD COLUMN detalles_evento JSONB DEFAULT '{}'::jsonb;
