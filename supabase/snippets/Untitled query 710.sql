-- ==========================================================
-- 0) ESQUEMAS (Casa de Piedra) + (opcional) clonado de tablas
-- ==========================================================

create schema if not exists finanzas_casadepiedra;

-- OPCIONAL: clonar estructura de tablas de finanzas -> finanzas_casadepiedra
-- (solo crea la tabla si NO existe en el destino)
do $$
declare r record;
begin
  if exists (select 1 from pg_namespace where nspname = 'finanzas') then
    for r in
      select tablename
      from pg_tables
      where schemaname = 'finanzas'
    loop
      if to_regclass(format('%I.%I', 'finanzas_casadepiedra', r.tablename)) is null then
        execute format(
          'create table %I.%I (like %I.%I including all);',
          'finanzas_casadepiedra', r.tablename,
          'finanzas', r.tablename
        );
      end if;
    end loop;
  end if;
end $$;

-- ==========================================================
-- 1) PROFILES: asegurar columnas mínimas (sin destruir extras)
-- ==========================================================

-- Si no existe, se crea con lo mínimo
create table if not exists public.profiles (
  id uuid primary key,
  email text,
  username text,
  role text not null default 'user',
  allowed_tenants text[] not null default array['plaza_mayor']::text[],
  app_metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Si ya existe, se “migra” agregando lo que falte
alter table public.profiles add column if not exists email text;
alter table public.profiles add column if not exists username text;
alter table public.profiles add column if not exists role text;
alter table public.profiles alter column role set default 'user';

alter table public.profiles add column if not exists allowed_tenants text[] not null default array['plaza_mayor']::text[];

alter table public.profiles add column if not exists app_metadata jsonb not null default '{}'::jsonb;

alter table public.profiles add column if not exists created_at timestamptz not null default now();
alter table public.profiles add column if not exists updated_at timestamptz not null default now();

-- Intentar agregar FK a auth.users si no existe (si falla por datos viejos, lo ignora)
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'profiles_id_fkey'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_id_fkey
      foreign key (id) references auth.users(id) on delete cascade;
  end if;
exception
  when others then
    -- Si tienes filas en profiles que no existen en auth.users, este FK puede fallar.
    -- En ese caso, limpia esas filas o inserta usuarios equivalentes y vuelve a correr.
    null;
end $$;

-- Constraint para que allowed_tenants solo contenga los 2 valores válidos
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'profiles_allowed_tenants_valid'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_allowed_tenants_valid
      check (allowed_tenants <@ array['plaza_mayor','casa_de_piedra']::text[]);
  end if;
end $$;

-- Índices útiles
create index if not exists profiles_email_idx on public.profiles (lower(email));
create index if not exists profiles_allowed_tenants_gin on public.profiles using gin (allowed_tenants);

-- updated_at automático
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

-- ==========================================================
-- 2) Helpers: leer rol del JWT + checks de admin/tenant
-- ==========================================================

-- Lee el claim "role" desde request.jwt.claims (json). :contentReference[oaicite:3]{index=3}
create or replace function public.jwt_role()
returns text
language sql
stable
as $$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$$;

-- is_admin como SECURITY DEFINER para evitar líos de RLS al checar admin
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

-- Acceso por cotizador (tenant)
create or replace function public.can_access_tenant(p_tenant text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    -- service_role bypass (para tareas admin)
    (public.jwt_role() = 'service_role')
    or
    -- admin ve todo
    public.is_admin()
    or
    -- user solo si tiene el tenant asignado
    exists (
      select 1
      from public.profiles p
      where p.id = auth.uid()
        and p_tenant = any(p.allowed_tenants)
    );
$$;

-- ==========================================================
-- 3) Trigger: auto-crear profile al registrarse (opcional)
-- ==========================================================

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, username, role, allowed_tenants, app_metadata)
  values (
    new.id,
    new.email,
    coalesce(split_part(new.email, '@', 1), 'Usuario'),
    'user',
    array['plaza_mayor']::text[],
    '{}'::jsonb
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- ==========================================================
-- 4) RLS en public.profiles
--    - user: solo su perfil
--    - admin: puede ver/editar todos
-- ==========================================================

alter table public.profiles enable row level security;

drop policy if exists profiles_select on public.profiles;
create policy profiles_select
on public.profiles
for select
using (
  (auth.uid() = id)
  or public.is_admin()
  or (public.jwt_role() = 'service_role')
);

drop policy if exists profiles_insert on public.profiles;
create policy profiles_insert
on public.profiles
for insert
with check (
  (auth.uid() = id)
  or public.is_admin()
  or (public.jwt_role() = 'service_role')
);

drop policy if exists profiles_update on public.profiles;
create policy profiles_update
on public.profiles
for update
using (
  (auth.uid() = id)
  or public.is_admin()
  or (public.jwt_role() = 'service_role')
)
with check (
  (auth.uid() = id)
  or public.is_admin()
  or (public.jwt_role() = 'service_role')
);

drop policy if exists profiles_delete on public.profiles;
create policy profiles_delete
on public.profiles
for delete
using (
  public.is_admin()
  or (public.jwt_role() = 'service_role')
);

-- Normalizar admins: siempre ambos módulos
update public.profiles
set allowed_tenants = array['plaza_mayor','casa_de_piedra']::text[]
where role = 'admin'
  and (allowed_tenants is distinct from array['plaza_mayor','casa_de_piedra']::text[]);

-- ==========================================================
-- 5) Permisos de esquema (por si te faltan)
-- ==========================================================

grant usage on schema finanzas to anon, authenticated, service_role;
grant usage on schema finanzas_casadepiedra to anon, authenticated, service_role;

grant all privileges on all tables in schema finanzas to anon, authenticated, service_role;
grant all privileges on all tables in schema finanzas_casadepiedra to anon, authenticated, service_role;

grant all privileges on all sequences in schema finanzas to anon, authenticated, service_role;
grant all privileges on all sequences in schema finanzas_casadepiedra to anon, authenticated, service_role;

alter default privileges in schema finanzas
grant all on tables to anon, authenticated, service_role;

alter default privileges in schema finanzas_casadepiedra
grant all on tables to anon, authenticated, service_role;

alter default privileges in schema finanzas
grant all on sequences to anon, authenticated, service_role;

alter default privileges in schema finanzas_casadepiedra
grant all on sequences to anon, authenticated, service_role;

-- ==========================================================
-- 6) RLS “tenant gate” para TODAS las tablas de ambos esquemas
--    - finanzas => plaza_mayor
--    - finanzas_casadepiedra => casa_de_piedra
-- ==========================================================

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

    -- SELECT
    execute format('drop policy if exists tenant_select on %I.%I;', r.schemaname, r.tablename);
    execute format(
      'create policy tenant_select on %I.%I for select using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );

    -- INSERT
    execute format('drop policy if exists tenant_insert on %I.%I;', r.schemaname, r.tablename);
    execute format(
      'create policy tenant_insert on %I.%I for insert with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );

    -- UPDATE
    execute format('drop policy if exists tenant_update on %I.%I;', r.schemaname, r.tablename);
    execute format(
      'create policy tenant_update on %I.%I for update using (public.can_access_tenant(%L)) with check (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name, tenant_name
    );

    -- DELETE
    execute format('drop policy if exists tenant_delete on %I.%I;', r.schemaname, r.tablename);
    execute format(
      'create policy tenant_delete on %I.%I for delete using (public.can_access_tenant(%L));',
      r.schemaname, r.tablename, tenant_name
    );
  end loop;
end $$;

-- ==========================================================
-- 7) RPC útil para index.html: saber qué módulos mostrar
-- ==========================================================

create or replace function public.get_my_module_access()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'role', coalesce(p.role, 'user'),
    'allowed_tenants', coalesce(p.allowed_tenants, array[]::text[]),
    'show_plaza_mayor', (public.is_admin() or ('plaza_mayor' = any(coalesce(p.allowed_tenants, array[]::text[])))),
    'show_casa_de_piedra', (public.is_admin() or ('casa_de_piedra' = any(coalesce(p.allowed_tenants, array[]::text[]))))
  )
  from public.profiles p
  where p.id = auth.uid();
$$;
