-- 0) Asegura helper para leer rol del JWT (service_role)
create or replace function public.jwt_role()
returns text
language sql
stable
as $$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$$;

-- 1) Activa RLS (si ya estaba, no pasa nada)
alter table public.profiles enable row level security;

-- 2) Borra TODAS las policies existentes en profiles (ojo: policyname, no polname)
do $$
declare p record;
begin
  for p in
    select policyname
    from pg_policies
    where schemaname = 'public'
      and tablename  = 'profiles'
  loop
    execute format('drop policy if exists %I on public.profiles;', p.policyname);
  end loop;
end $$;

-- 3) Crea policies limpias: solo mi fila (y service_role)
create policy profiles_select_own
on public.profiles
for select
using (
  (auth.uid() is not null and auth.uid() = id)
  or (public.jwt_role() = 'service_role')
);

create policy profiles_insert_own
on public.profiles
for insert
with check (
  (auth.uid() is not null and auth.uid() = id)
  or (public.jwt_role() = 'service_role')
);

create policy profiles_update_own
on public.profiles
for update
using (
  (auth.uid() is not null and auth.uid() = id)
  or (public.jwt_role() = 'service_role')
)
with check (
  (auth.uid() is not null and auth.uid() = id)
  or (public.jwt_role() = 'service_role')
);

create policy profiles_delete_sr
on public.profiles
for delete
using (public.jwt_role() = 'service_role');
