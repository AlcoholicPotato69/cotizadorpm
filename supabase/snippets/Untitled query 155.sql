-- Normaliza allowed_tenants existentes (lower + trim)
update public.profiles
set allowed_tenants = (
  select coalesce(array_agg(lower(trim(x))), array[]::text[])
  from unnest(allowed_tenants) as x
)
where allowed_tenants is not null;

-- Reemplaza can_access_tenant por versión robusta
create or replace function public.can_access_tenant(p_tenant text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    -- service_role puede pasar (admin/batch)
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role') = 'service_role'
    or
    -- admin ve ambos
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and p.role = 'admin'
    )
    or
    -- user: solo si está autenticado y tiene el tenant asignado
    (
      auth.uid() is not null
      and exists (
        select 1
        from public.profiles p
        where p.id = auth.uid()
          and lower(trim(p_tenant)) = any (
            select lower(trim(t)) from unnest(p.allowed_tenants) as t
          )
      )
    );
$$;

-- Re-aplica policies tenant_* a todas las tablas de ambos schemas (finanzas y finanzas_casadepiedra)
do $$
declare r record;
declare tenant_name text;
begin
  for r in
    select schemaname, tablename
    from pg_tables
    where schemaname in ('finanzas', 'finanzas_casadepiedra')
  loop
    tenant_name := case r.schemaname
      when 'finanzas' then 'plaza_mayor'
      else 'casa_de_piedra'
    end;

    execute format('alter table %I.%I enable row level security;', r.schemaname, r.tablename);
    execute format('alter table %I.%I force row level security;', r.schemaname, r.tablename);

    execute format('drop policy if exists tenant_select on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_insert on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_update on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_delete on %I.%I;', r.schemaname, r.tablename);

    execute format(
      'create policy tenant_select on %I.%I for select using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );
    execute format(
      'create policy tenant_insert on %I.%I for insert with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );
    execute format(
      'create policy tenant_update on %I.%I for update using (public.can_access_tenant(%L)) with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name, tenant_name
    );
    execute format(
      'create policy tenant_delete on %I.%I for delete using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );
  end loop;
end $$;
