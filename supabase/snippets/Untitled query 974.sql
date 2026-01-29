select set_config(
  'request.jwt.claims',
  json_build_object('sub','5c1674bb-74fc-43b4-b81a-38cfa32e0ba3','role','authenticated')::text,
  true
);

select auth.uid() as uid,
       public.can_access_tenant('plaza_mayor') as can_pm,
       public.can_access_tenant('casa_de_piedra') as can_cp;
