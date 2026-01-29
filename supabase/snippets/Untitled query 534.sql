-- =========================
-- 1) TABLA public.profiles
-- =========================

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  username text,
  role text not null default 'user',              -- lo usa tu hub: 'admin' desbloquea settings
  tenant text not null default 'plaza_mayor',     -- 'plaza_mayor' | 'casa_de_piedra'
  app_metadata jsonb not null default '{}'::jsonb, -- lo usa tu hub: app_metadata.finanzas.permissions
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists profiles_email_idx on public.profiles (lower(email));
create index if not exists profiles_tenant_idx on public.profiles (tenant);

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

-- =========================
-- 2) RLS básico (recomendado)
-- =========================
alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
on public.profiles for select
using (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
on public.profiles for update
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "profiles_insert_self" on public.profiles;
create policy "profiles_insert_self"
on public.profiles for insert
with check (auth.uid() = id);

-- =========================
-- 3) Trigger para crear profile al registrarse (opcional pero útil)
-- =========================
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, username, role, tenant, app_metadata)
  values (
    new.id,
    new.email,
    coalesce(split_part(new.email, '@', 1), 'Usuario'),
    'user',
    'plaza_mayor',
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
