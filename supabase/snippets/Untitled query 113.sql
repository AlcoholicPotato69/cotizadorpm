-- =================================================================
-- 1. MIGRACIÓN DE DATOS (Adios Tenants, Hola Roles)
-- =================================================================

-- Convertir usuarios de Plaza Mayor
UPDATE public.profiles
SET role = 'plaza_mayor'
WHERE role = 'user' AND (tenant ILIKE '%plaza%' OR tenant IS NULL); 
-- Nota: Asumimos que los NULL por defecto van a Plaza Mayor, ajusta si no es así.

-- Convertir usuarios de Casa de Piedra
UPDATE public.profiles
SET role = 'casa_de_piedra'
WHERE role = 'user' AND tenant ILIKE '%casa%';

-- Verificar que no queden 'users' genéricos
-- (Opcional) SELECT * FROM public.profiles;