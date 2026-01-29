-- =========================================================
-- 0) Asegurar columna allowed_tenants en profiles (si aplica)
-- =========================================================
alter table public.profiles
  add column if not exists allowed_tenants text[] not null default array['plaza_mayor']::text[];

-- Solo permitir estos valores
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'profiles_allowed_tenants_valid'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_allowed_tenants_valid
      check (allowed_tenants <@ array['plaza_mayor','casa_de_piedra']::text[]);
  end if;
end $$;

-- =========================================================
-- 1) Helpers: role del JWT + admin + acceso por tenant
-- =========================================================
create or replace function public.jwt_role()
returns text
language sql
stable
as $$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  );
$$;

create or replace function public.can_access_tenant(p_tenant text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    (public.jwt_role() = 'service_role')
    or public.is_admin()
    or exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p_tenant = any(p.allowed_tenants)
    );
$$;

-- =========================================================
-- 2) Aplicar RLS a todas las tablas por esquema/tenant
--     finanzas -> plaza_mayor
--     finanzas_casadepiedra o finanzas_cp -> casa_de_piedra
-- =========================================================
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

    -- Habilitar y forzar RLS
    execute format('alter table %I.%I enable row level security;', r.schemaname, r.tablename);
    execute format('alter table %I.%I force row level security;', r.schemaname, r.tablename);

    -- Limpia policies anteriores si existían
    execute format('drop policy if exists tenant_select on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_insert on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_update on %I.%I;', r.schemaname, r.tablename);
    execute format('drop policy if exists tenant_delete on %I.%I;', r.schemaname, r.tablename);

    -- SELECT
    execute format(
      'create policy tenant_select on %I.%I for select using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );

    -- INSERT
    execute format(
      'create policy tenant_insert on %I.%I for insert with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );

    -- UPDATE
    execute format(
      'create policy tenant_update on %I.%I for update using (public.can_access_tenant(%L)) with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name, tenant_name
    );

    -- DELETE
    execute format(
      'create policy tenant_delete on %I.%I for delete using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );

  end loop;
end $$;

-- =========================================================
-- 3) Normalizar admins: siempre pueden ambos
-- =========================================================
update public.profiles
set allowed_tenants = array['plaza_mayor','casa_de_piedra']::text[]
where role = 'admin'
  and (allowed_tenants is distinct from array['plaza_mayor','casa_de_piedra']::text[]);
