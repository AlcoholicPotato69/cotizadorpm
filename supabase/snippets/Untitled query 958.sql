-- Sustituye el correo por el del usuario que falla
SELECT * FROM public.users -- O public.profiles, según tu estructura
WHERE email = 'admin@plazamayor.com';