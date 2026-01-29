update public.profiles
set role = 'user',
    allowed_tenants = array['casa_de_piedra']::text[]
where id = '5c1674bb-74fc-43b4-b81a-38cfa32e0ba3';
