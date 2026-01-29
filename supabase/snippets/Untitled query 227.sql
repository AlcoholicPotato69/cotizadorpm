update public.profiles
set role = 'user',
    allowed_tenants = array['casa_de_piedra']::text[]
where email = 'admin@casadepiedra.com';
