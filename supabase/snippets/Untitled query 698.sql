-- =========================
-- ESQUEMA Casa de Piedra
-- =========================
create schema if not exists finanzas_casadepiedra;

-- Clonar TODAS las tablas de finanzas → finanzas_casadepiedra
do $$
declare r record;
begin
  for r in
    select tablename
    from pg_tables
    where schemaname = 'finanzas'
  loop
    execute format(
      'create table if not exists finanzas_casadepiedra.%I (like finanzas.%I including all);',
      r.tablename, r.tablename
    );
  end loop;
end $$;

-- Permisos de esquema (como ya hiciste para finanzas)
grant usage on schema finanzas_casadepiedra to anon, authenticated, service_role;
grant all privileges on all tables in schema finanzas_casadepiedra to anon, authenticated, service_role;
grant all privileges on all sequences in schema finanzas_casadepiedra to anon, authenticated, service_role;

alter default privileges in schema finanzas_casadepiedra
grant all on tables to anon, authenticated, service_role;

alter default privileges in schema finanzas_casadepiedra
grant all on sequences to anon, authenticated, service_role;
