alter table "finanzas"."espacios" add column "etiquetas" jsonb default '[]'::jsonb;


  create policy "Anon_Ve_Fechas_Ocupadas_PM"
  on "finanzas"."cotizaciones"
  as permissive
  for select
  to anon
using ((status = ANY (ARRAY['aprobada'::text, 'finalizada'::text])));



  create policy "Publico_Manda_Cotizaciones_PM"
  on "finanzas"."cotizaciones"
  as permissive
  for insert
  to anon
with check (true);



  create policy "Publico_Ve_Fechas_PM"
  on "finanzas"."cotizaciones"
  as permissive
  for select
  to anon
using ((status = ANY (ARRAY['aprobada'::text, 'finalizada'::text])));



  create policy "Anon_Ve_Espacios_PM"
  on "finanzas"."espacios"
  as permissive
  for select
  to anon
using ((activo = true));



  create policy "Publico_Ve_Espacios_Activos"
  on "finanzas"."espacios"
  as permissive
  for select
  to anon
using ((activo = true));


alter table "finanzas_casadepiedra"."cotizaciones" drop column "cliente_telefono";

alter table "finanzas_casadepiedra"."cotizaciones" add column "detalles_evento" jsonb default '{}'::jsonb;

alter table "finanzas_casadepiedra"."espacios" add column "dias_bloqueados" jsonb default '[]'::jsonb;

alter table "finanzas_casadepiedra"."espacios" add column "etiquetas" jsonb default '[]'::jsonb;


  create policy "Anon_Crea_Cotizaciones_CP"
  on "finanzas_casadepiedra"."cotizaciones"
  as permissive
  for insert
  to anon
with check (true);



  create policy "Anon_Ve_Fechas_Ocupadas_CP"
  on "finanzas_casadepiedra"."cotizaciones"
  as permissive
  for select
  to anon
using ((status = ANY (ARRAY['aprobada'::text, 'finalizada'::text])));



  create policy "Publico_Manda_Cotizaciones_CP"
  on "finanzas_casadepiedra"."cotizaciones"
  as permissive
  for insert
  to anon
with check (true);



  create policy "Publico_Ve_Fechas_CP"
  on "finanzas_casadepiedra"."cotizaciones"
  as permissive
  for select
  to anon
using ((status = ANY (ARRAY['aprobada'::text, 'finalizada'::text])));



  create policy "Anon_Ve_Espacios_CP"
  on "finanzas_casadepiedra"."espacios"
  as permissive
  for select
  to anon
using ((activo = true));



