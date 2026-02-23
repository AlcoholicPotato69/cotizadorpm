-- Insertar los buckets automáticamente si no existen
INSERT INTO storage.buckets (id, name, public) 
VALUES 
  ('Espacios', 'Espacios', true),
  ('documentos', 'documentos', true),
  ('documentos-cp', 'documentos-cp', true)
ON CONFLICT (id) DO NOTHING;

-- (Opcional pero recomendado) Permitir a los usuarios subir, ver y borrar archivos en estos buckets
CREATE POLICY "Permitir todo a usuarios autenticados" ON storage.objects
FOR ALL TO authenticated USING (bucket_id IN ('Espacios', 'documentos', 'documentos-cp'));

CREATE POLICY "Permitir lectura al publico" ON storage.objects
FOR SELECT TO public USING (bucket_id IN ('Espacios'));