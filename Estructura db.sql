


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "finanzas";


ALTER SCHEMA "finanzas" OWNER TO "supabase_admin";


COMMENT ON SCHEMA "finanzas" IS 'Módulo de Cotizador (Versión Local Independiente)';



CREATE SCHEMA IF NOT EXISTS "finanzas_casadepiedra";


ALTER SCHEMA "finanzas_casadepiedra" OWNER TO "supabase_admin";


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."can_access_cp"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','casa_de_piedra')
    OR public.profile_has_tenant_norm('casa_de_piedra');
$$;


ALTER FUNCTION "public"."can_access_cp"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."can_access_pm"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT
    public.profile_role_norm() IN ('admin','ambos','plaza_mayor')
    OR public.profile_has_tenant_norm('plaza_mayor');
$$;


ALTER FUNCTION "public"."can_access_pm"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."get_my_module_access"() RETURNS "jsonb"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select jsonb_build_object(
    'role', coalesce(p.role, 'user'),
    'allowed_tenants', coalesce(p.allowed_tenants, array[]::text[]),
    'show_plaza_mayor', (public.is_admin() or ('plaza_mayor' = any(coalesce(p.allowed_tenants, array[]::text[])))),
    'show_casa_de_piedra', (public.is_admin() or ('casa_de_piedra' = any(coalesce(p.allowed_tenants, array[]::text[]))))
  )
  from public.profiles p
  where p.id = auth.uid();
$$;


ALTER FUNCTION "public"."get_my_module_access"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."get_my_role"() RETURNS "text"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth', 'extensions'
    AS $$
DECLARE
  current_role text;
BEGIN
  -- Obtenemos el rol directo del perfil
  SELECT role INTO current_role
  FROM public.profiles
  WHERE id = auth.uid();
  
  RETURN current_role;
END;
$$;


ALTER FUNCTION "public"."get_my_role"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
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


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."handle_new_user_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth', 'extensions'
    AS $$
begin
  insert into public.profiles (id, username, role, app_metadata)
  values (new.id, split_part(new.email, '@', 1), 'admin', '{}'::jsonb)
  on conflict (id) do nothing;
  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user_profile"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."has_tenant_access"("tenant" "text") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND (
        lower(coalesce(p.role,'')) = 'admin'
        OR lower(tenant) = ANY (SELECT lower(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x)
      )
  );
$$;


ALTER FUNCTION "public"."has_tenant_access"("tenant" "text") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."is_admin"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT public.profile_role_norm() = 'admin';
$$;


ALTER FUNCTION "public"."is_admin"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."jwt_role"() RETURNS "text"
    LANGUAGE "sql" STABLE
    SET "search_path" TO 'public', 'extensions'
    AS $$
  select nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role';
$$;


ALTER FUNCTION "public"."jwt_role"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."normalize_key"("t" "text") RETURNS "text"
    LANGUAGE "sql" IMMUTABLE
    SET "search_path" TO 'public'
    AS $$
  SELECT trim(both '_' FROM regexp_replace(lower(coalesce(t,'')), '[^a-z0-9]+', '_', 'g'));
$$;


ALTER FUNCTION "public"."normalize_key"("t" "text") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles p
    WHERE p.id = auth.uid()
      AND public.normalize_key(tenant) = ANY (
        SELECT public.normalize_key(x) FROM unnest(coalesce(p.allowed_tenants,'{}'::text[])) x
      )
  );
$$;


ALTER FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."profile_role"() RETURNS "text"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT lower(coalesce(p.role,''))
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;


ALTER FUNCTION "public"."profile_role"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."profile_role_norm"() RETURNS "text"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    SET "row_security" TO 'off'
    AS $$
  SELECT public.normalize_key(p.role)
  FROM public.profiles p
  WHERE p.id = auth.uid()
  LIMIT 1;
$$;


ALTER FUNCTION "public"."profile_role_norm"() OWNER TO "supabase_admin";


CREATE OR REPLACE FUNCTION "public"."set_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO 'public', 'extensions'
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_updated_at"() OWNER TO "supabase_admin";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "finanzas"."clientes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nombre_completo" "text" NOT NULL,
    "telefono" "text",
    "correo" "text",
    "rfc" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "finanzas"."clientes" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "finanzas"."conceptos_catalogo" (
    "id" bigint NOT NULL,
    "nombre" "text" NOT NULL,
    "precio_sugerido" numeric DEFAULT 0,
    "activo" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);

ALTER TABLE ONLY "finanzas"."conceptos_catalogo" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."conceptos_catalogo" OWNER TO "supabase_admin";


ALTER TABLE "finanzas"."conceptos_catalogo" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas"."conceptos_catalogo_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "finanzas"."cotizaciones" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "creado_por" "uuid",
    "espacio_id" bigint,
    "espacio_nombre" "text",
    "espacio_clave" "text",
    "cliente_nombre" "text",
    "cliente_rfc" "text",
    "cliente_contacto" "text",
    "cliente_email" "text",
    "cliente_telefono" "text",
    "fecha_inicio" "date" NOT NULL,
    "fecha_fin" "date" NOT NULL,
    "precio_final" numeric NOT NULL,
    "desglose_precios" "jsonb",
    "status" "text" DEFAULT 'aprobada'::"text",
    "numero_orden" "text",
    "numero_contrato" "text",
    "factura_pdf_url" "text",
    "factura_xml_url" "text",
    "contrato_url" "text",
    "url_cotizacion_final" "text",
    "url_orden_compra" "text",
    "fecha_orden_compra" timestamp with time zone,
    "datos_fiscales" "jsonb" DEFAULT '{}'::"jsonb",
    "conceptos_adicionales" "jsonb" DEFAULT '[]'::"jsonb",
    "tipo_ajuste" "text" DEFAULT 'ninguno'::"text",
    "valor_ajuste" numeric DEFAULT 0,
    "ajuste_es_porcentaje" boolean DEFAULT false,
    "desglose_impuestos" "jsonb" DEFAULT '[]'::"jsonb",
    "historial_pagos" "jsonb" DEFAULT '[]'::"jsonb",
    "datos_factura" "jsonb" DEFAULT '{}'::"jsonb",
    "cliente_id" "uuid"
);

ALTER TABLE ONLY "finanzas"."cotizaciones" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."cotizaciones" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "finanzas"."espacios" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "clave" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "tipo" "text" NOT NULL,
    "descripcion" "text",
    "requisitos" "text",
    "imagen_url" "text",
    "activo" boolean DEFAULT true,
    "precio_base" numeric DEFAULT 0,
    "ajuste_tipo" "text" DEFAULT 'ninguno'::"text",
    "ajuste_porcentaje" integer DEFAULT 0,
    "activa" boolean DEFAULT true,
    "impuestos_ids" "jsonb" DEFAULT '[]'::"jsonb",
    "color" character varying DEFAULT '#374151'::character varying
);

ALTER TABLE ONLY "finanzas"."espacios" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."espacios" OWNER TO "supabase_admin";


ALTER TABLE "finanzas"."espacios" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas"."espacios_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "finanzas"."impuestos" (
    "id" bigint NOT NULL,
    "nombre" "text" NOT NULL,
    "porcentaje" numeric NOT NULL,
    "activo" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()),
    "impuestos_aplicados" "jsonb"
);

ALTER TABLE ONLY "finanzas"."impuestos" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."impuestos" OWNER TO "supabase_admin";


ALTER TABLE "finanzas"."impuestos" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas"."impuestos_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "finanzas_casadepiedra"."clientes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nombre_completo" "text" NOT NULL,
    "telefono" "text",
    "correo" "text",
    "rfc" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "finanzas_casadepiedra"."clientes" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "finanzas_casadepiedra"."conceptos_catalogo" (
    "id" bigint NOT NULL,
    "nombre" "text" NOT NULL,
    "precio_sugerido" numeric DEFAULT 0,
    "activo" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "now"()
);

ALTER TABLE ONLY "finanzas_casadepiedra"."conceptos_catalogo" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."conceptos_catalogo" OWNER TO "supabase_admin";


ALTER TABLE "finanzas_casadepiedra"."conceptos_catalogo" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas_casadepiedra"."conceptos_catalogo_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "finanzas_casadepiedra"."cotizaciones" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "creado_por" "uuid",
    "espacio_id" bigint,
    "espacio_nombre" "text",
    "espacio_clave" "text",
    "cliente_nombre" "text",
    "cliente_rfc" "text",
    "cliente_contacto" "text",
    "cliente_email" "text",
    "cliente_telefono" "text",
    "fecha_inicio" "date" NOT NULL,
    "fecha_fin" "date" NOT NULL,
    "precio_final" numeric NOT NULL,
    "desglose_precios" "jsonb",
    "status" "text" DEFAULT 'aprobada'::"text",
    "numero_orden" "text",
    "numero_contrato" "text",
    "factura_pdf_url" "text",
    "factura_xml_url" "text",
    "contrato_url" "text",
    "url_cotizacion_final" "text",
    "url_orden_compra" "text",
    "fecha_orden_compra" timestamp with time zone,
    "datos_fiscales" "jsonb" DEFAULT '{}'::"jsonb",
    "conceptos_adicionales" "jsonb" DEFAULT '[]'::"jsonb",
    "tipo_ajuste" "text" DEFAULT 'ninguno'::"text",
    "valor_ajuste" numeric DEFAULT 0,
    "ajuste_es_porcentaje" boolean DEFAULT false,
    "desglose_impuestos" "jsonb" DEFAULT '[]'::"jsonb",
    "historial_pagos" "jsonb" DEFAULT '[]'::"jsonb",
    "datos_factura" "jsonb" DEFAULT '{}'::"jsonb",
    "cliente_id" "uuid"
);

ALTER TABLE ONLY "finanzas_casadepiedra"."cotizaciones" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."cotizaciones" OWNER TO "supabase_admin";


CREATE TABLE IF NOT EXISTS "finanzas_casadepiedra"."espacios" (
    "id" bigint NOT NULL,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "clave" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "tipo" "text" NOT NULL,
    "descripcion" "text",
    "requisitos" "text",
    "imagen_url" "text",
    "activo" boolean DEFAULT true,
    "precio_base" numeric DEFAULT 0,
    "ajuste_tipo" "text" DEFAULT 'ninguno'::"text",
    "ajuste_porcentaje" integer DEFAULT 0,
    "activa" boolean DEFAULT true,
    "impuestos_ids" "jsonb" DEFAULT '[]'::"jsonb",
    "color" character varying DEFAULT '#374151'::character varying
);

ALTER TABLE ONLY "finanzas_casadepiedra"."espacios" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."espacios" OWNER TO "supabase_admin";


ALTER TABLE "finanzas_casadepiedra"."espacios" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas_casadepiedra"."espacios_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "finanzas_casadepiedra"."impuestos" (
    "id" bigint NOT NULL,
    "nombre" "text" NOT NULL,
    "porcentaje" numeric NOT NULL,
    "activo" boolean DEFAULT true,
    "created_at" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()),
    "impuestos_aplicados" "jsonb"
);

ALTER TABLE ONLY "finanzas_casadepiedra"."impuestos" FORCE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."impuestos" OWNER TO "supabase_admin";


ALTER TABLE "finanzas_casadepiedra"."impuestos" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "finanzas_casadepiedra"."impuestos_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "email" "text",
    "username" "text",
    "role" "text" DEFAULT 'user'::"text" NOT NULL,
    "tenant" "text" DEFAULT 'plaza_mayor'::"text" NOT NULL,
    "app_metadata" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "allowed_tenants" "text"[] DEFAULT ARRAY['plaza_mayor'::"text"] NOT NULL,
    CONSTRAINT "profiles_allowed_tenants_valid" CHECK (("allowed_tenants" <@ ARRAY['plaza_mayor'::"text", 'casa_de_piedra'::"text"]))
);


ALTER TABLE "public"."profiles" OWNER TO "supabase_admin";


ALTER TABLE ONLY "finanzas"."clientes"
    ADD CONSTRAINT "clientes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas"."conceptos_catalogo"
    ADD CONSTRAINT "conceptos_catalogo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas"."cotizaciones"
    ADD CONSTRAINT "cotizaciones_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas"."espacios"
    ADD CONSTRAINT "espacios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas"."impuestos"
    ADD CONSTRAINT "impuestos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas_casadepiedra"."clientes"
    ADD CONSTRAINT "clientes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas_casadepiedra"."conceptos_catalogo"
    ADD CONSTRAINT "conceptos_catalogo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas_casadepiedra"."cotizaciones"
    ADD CONSTRAINT "cotizaciones_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas_casadepiedra"."espacios"
    ADD CONSTRAINT "espacios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "finanzas_casadepiedra"."impuestos"
    ADD CONSTRAINT "impuestos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_finanzas_clientes_correo" ON "finanzas"."clientes" USING "btree" ("lower"("correo"));



CREATE INDEX "idx_finanzas_clientes_nombre" ON "finanzas"."clientes" USING "btree" ("lower"("nombre_completo"));



CREATE INDEX "idx_finanzas_clientes_rfc" ON "finanzas"."clientes" USING "btree" ("rfc");



CREATE INDEX "idx_finanzas_cotizaciones_cliente_id" ON "finanzas"."cotizaciones" USING "btree" ("cliente_id");



CREATE INDEX "idx_fcdp_clientes_correo" ON "finanzas_casadepiedra"."clientes" USING "btree" ("lower"("correo"));



CREATE INDEX "idx_fcdp_clientes_nombre" ON "finanzas_casadepiedra"."clientes" USING "btree" ("lower"("nombre_completo"));



CREATE INDEX "idx_fcdp_clientes_rfc" ON "finanzas_casadepiedra"."clientes" USING "btree" ("rfc");



CREATE INDEX "idx_fcdp_cotizaciones_cliente_id" ON "finanzas_casadepiedra"."cotizaciones" USING "btree" ("cliente_id");



CREATE INDEX "profiles_allowed_tenants_gin" ON "public"."profiles" USING "gin" ("allowed_tenants");



CREATE INDEX "profiles_email_idx" ON "public"."profiles" USING "btree" ("lower"("email"));



CREATE INDEX "profiles_tenant_idx" ON "public"."profiles" USING "btree" ("tenant");



CREATE OR REPLACE TRIGGER "trg_finanzas_clientes_updated_at" BEFORE UPDATE ON "finanzas"."clientes" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_fcdp_clientes_updated_at" BEFORE UPDATE ON "finanzas_casadepiedra"."clientes" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "profiles_set_updated_at" BEFORE UPDATE ON "public"."profiles" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



ALTER TABLE ONLY "finanzas"."cotizaciones"
    ADD CONSTRAINT "cotizaciones_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "finanzas"."clientes"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "finanzas"."cotizaciones"
    ADD CONSTRAINT "fk_cotizaciones_espacios" FOREIGN KEY ("espacio_id") REFERENCES "finanzas"."espacios"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "finanzas_casadepiedra"."cotizaciones"
    ADD CONSTRAINT "cotizaciones_cliente_id_fkey" FOREIGN KEY ("cliente_id") REFERENCES "finanzas_casadepiedra"."clientes"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE "finanzas"."clientes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."conceptos_catalogo" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."cotizaciones" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas"."espacios" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "fin_clientes_delete" ON "finanzas"."clientes" FOR DELETE TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_clientes_insert" ON "finanzas"."clientes" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_clientes_select" ON "finanzas"."clientes" FOR SELECT TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_clientes_update" ON "finanzas"."clientes" FOR UPDATE TO "authenticated" USING ("public"."can_access_pm"()) WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_conceptos_catalogo_admin_delete" ON "finanzas"."conceptos_catalogo" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "fin_conceptos_catalogo_admin_insert" ON "finanzas"."conceptos_catalogo" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "fin_conceptos_catalogo_admin_update" ON "finanzas"."conceptos_catalogo" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "fin_conceptos_catalogo_select" ON "finanzas"."conceptos_catalogo" FOR SELECT TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_cotizaciones_delete" ON "finanzas"."cotizaciones" FOR DELETE TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_cotizaciones_insert" ON "finanzas"."cotizaciones" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_cotizaciones_select" ON "finanzas"."cotizaciones" FOR SELECT TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_cotizaciones_update" ON "finanzas"."cotizaciones" FOR UPDATE TO "authenticated" USING ("public"."can_access_pm"()) WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_espacios_delete" ON "finanzas"."espacios" FOR DELETE TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_espacios_insert" ON "finanzas"."espacios" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_espacios_select" ON "finanzas"."espacios" FOR SELECT TO "authenticated" USING ("public"."can_access_pm"());



CREATE POLICY "fin_espacios_update" ON "finanzas"."espacios" FOR UPDATE TO "authenticated" USING ("public"."can_access_pm"()) WITH CHECK ("public"."can_access_pm"());



CREATE POLICY "fin_impuestos_admin_delete" ON "finanzas"."impuestos" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "fin_impuestos_admin_insert" ON "finanzas"."impuestos" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "fin_impuestos_admin_update" ON "finanzas"."impuestos" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "fin_impuestos_select" ON "finanzas"."impuestos" FOR SELECT TO "authenticated" USING ("public"."can_access_pm"());



ALTER TABLE "finanzas"."impuestos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."clientes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."conceptos_catalogo" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."cotizaciones" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "cp_clientes_delete" ON "finanzas_casadepiedra"."clientes" FOR DELETE TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_clientes_insert" ON "finanzas_casadepiedra"."clientes" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_clientes_select" ON "finanzas_casadepiedra"."clientes" FOR SELECT TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_clientes_update" ON "finanzas_casadepiedra"."clientes" FOR UPDATE TO "authenticated" USING ("public"."can_access_cp"()) WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_conceptos_catalogo_admin_delete" ON "finanzas_casadepiedra"."conceptos_catalogo" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "cp_conceptos_catalogo_admin_insert" ON "finanzas_casadepiedra"."conceptos_catalogo" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "cp_conceptos_catalogo_admin_update" ON "finanzas_casadepiedra"."conceptos_catalogo" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "cp_conceptos_catalogo_select" ON "finanzas_casadepiedra"."conceptos_catalogo" FOR SELECT TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_cotizaciones_delete" ON "finanzas_casadepiedra"."cotizaciones" FOR DELETE TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_cotizaciones_insert" ON "finanzas_casadepiedra"."cotizaciones" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_cotizaciones_select" ON "finanzas_casadepiedra"."cotizaciones" FOR SELECT TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_cotizaciones_update" ON "finanzas_casadepiedra"."cotizaciones" FOR UPDATE TO "authenticated" USING ("public"."can_access_cp"()) WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_espacios_delete" ON "finanzas_casadepiedra"."espacios" FOR DELETE TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_espacios_insert" ON "finanzas_casadepiedra"."espacios" FOR INSERT TO "authenticated" WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_espacios_select" ON "finanzas_casadepiedra"."espacios" FOR SELECT TO "authenticated" USING ("public"."can_access_cp"());



CREATE POLICY "cp_espacios_update" ON "finanzas_casadepiedra"."espacios" FOR UPDATE TO "authenticated" USING ("public"."can_access_cp"()) WITH CHECK ("public"."can_access_cp"());



CREATE POLICY "cp_impuestos_admin_delete" ON "finanzas_casadepiedra"."impuestos" FOR DELETE TO "authenticated" USING ("public"."is_admin"());



CREATE POLICY "cp_impuestos_admin_insert" ON "finanzas_casadepiedra"."impuestos" FOR INSERT TO "authenticated" WITH CHECK ("public"."is_admin"());



CREATE POLICY "cp_impuestos_admin_update" ON "finanzas_casadepiedra"."impuestos" FOR UPDATE TO "authenticated" USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());



CREATE POLICY "cp_impuestos_select" ON "finanzas_casadepiedra"."impuestos" FOR SELECT TO "authenticated" USING ("public"."can_access_cp"());



ALTER TABLE "finanzas_casadepiedra"."espacios" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "finanzas_casadepiedra"."impuestos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "profiles_insert_own" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK ((("id" = ( SELECT "auth"."uid"() AS "uid")) OR "public"."is_admin"()));



CREATE POLICY "profiles_select_self_or_admin" ON "public"."profiles" FOR SELECT TO "authenticated" USING ((("id" = ( SELECT "auth"."uid"() AS "uid")) OR "public"."is_admin"()));



CREATE POLICY "profiles_update_self_or_admin" ON "public"."profiles" FOR UPDATE TO "authenticated" USING ((("id" = ( SELECT "auth"."uid"() AS "uid")) OR "public"."is_admin"())) WITH CHECK ((("id" = ( SELECT "auth"."uid"() AS "uid")) OR "public"."is_admin"()));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






GRANT USAGE ON SCHEMA "finanzas" TO "anon";
GRANT ALL ON SCHEMA "finanzas" TO "authenticated";
GRANT USAGE ON SCHEMA "finanzas" TO "service_role";



GRANT USAGE ON SCHEMA "finanzas_casadepiedra" TO "anon";
GRANT USAGE ON SCHEMA "finanzas_casadepiedra" TO "authenticated";
GRANT USAGE ON SCHEMA "finanzas_casadepiedra" TO "service_role";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";































































































































































GRANT ALL ON FUNCTION "public"."can_access_cp"() TO "postgres";
GRANT ALL ON FUNCTION "public"."can_access_cp"() TO "anon";
GRANT ALL ON FUNCTION "public"."can_access_cp"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_access_cp"() TO "service_role";



GRANT ALL ON FUNCTION "public"."can_access_pm"() TO "postgres";
GRANT ALL ON FUNCTION "public"."can_access_pm"() TO "anon";
GRANT ALL ON FUNCTION "public"."can_access_pm"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_access_pm"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_my_module_access"() TO "postgres";
GRANT ALL ON FUNCTION "public"."get_my_module_access"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_module_access"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_module_access"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_my_role"() TO "postgres";
GRANT ALL ON FUNCTION "public"."get_my_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_my_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_my_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "postgres";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "postgres";
GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "service_role";



GRANT ALL ON FUNCTION "public"."has_tenant_access"("tenant" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."has_tenant_access"("tenant" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."has_tenant_access"("tenant" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_tenant_access"("tenant" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_admin"() TO "postgres";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "anon";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_admin"() TO "service_role";



GRANT ALL ON FUNCTION "public"."jwt_role"() TO "postgres";
GRANT ALL ON FUNCTION "public"."jwt_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."jwt_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."jwt_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."normalize_key"("t" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."normalize_key"("t" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."normalize_key"("t" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."normalize_key"("t" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") TO "postgres";
GRANT ALL ON FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."profile_has_tenant_norm"("tenant" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."profile_role"() TO "postgres";
GRANT ALL ON FUNCTION "public"."profile_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."profile_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."profile_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."profile_role_norm"() TO "postgres";
GRANT ALL ON FUNCTION "public"."profile_role_norm"() TO "anon";
GRANT ALL ON FUNCTION "public"."profile_role_norm"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."profile_role_norm"() TO "service_role";



GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "postgres";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "service_role";


















GRANT ALL ON TABLE "finanzas"."clientes" TO "anon";
GRANT ALL ON TABLE "finanzas"."clientes" TO "authenticated";
GRANT ALL ON TABLE "finanzas"."clientes" TO "service_role";



GRANT ALL ON TABLE "finanzas"."conceptos_catalogo" TO "anon";
GRANT ALL ON TABLE "finanzas"."conceptos_catalogo" TO "authenticated";
GRANT ALL ON TABLE "finanzas"."conceptos_catalogo" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas"."conceptos_catalogo_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas"."conceptos_catalogo_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas"."conceptos_catalogo_id_seq" TO "service_role";



GRANT ALL ON TABLE "finanzas"."cotizaciones" TO "anon";
GRANT ALL ON TABLE "finanzas"."cotizaciones" TO "authenticated";
GRANT ALL ON TABLE "finanzas"."cotizaciones" TO "service_role";



GRANT ALL ON TABLE "finanzas"."espacios" TO "anon";
GRANT ALL ON TABLE "finanzas"."espacios" TO "authenticated";
GRANT ALL ON TABLE "finanzas"."espacios" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas"."espacios_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas"."espacios_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas"."espacios_id_seq" TO "service_role";



GRANT ALL ON TABLE "finanzas"."impuestos" TO "anon";
GRANT ALL ON TABLE "finanzas"."impuestos" TO "authenticated";
GRANT ALL ON TABLE "finanzas"."impuestos" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas"."impuestos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas"."impuestos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas"."impuestos_id_seq" TO "service_role";



GRANT ALL ON TABLE "finanzas_casadepiedra"."clientes" TO "anon";
GRANT ALL ON TABLE "finanzas_casadepiedra"."clientes" TO "authenticated";
GRANT ALL ON TABLE "finanzas_casadepiedra"."clientes" TO "service_role";



GRANT ALL ON TABLE "finanzas_casadepiedra"."conceptos_catalogo" TO "anon";
GRANT ALL ON TABLE "finanzas_casadepiedra"."conceptos_catalogo" TO "authenticated";
GRANT ALL ON TABLE "finanzas_casadepiedra"."conceptos_catalogo" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."conceptos_catalogo_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."conceptos_catalogo_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."conceptos_catalogo_id_seq" TO "service_role";



GRANT ALL ON TABLE "finanzas_casadepiedra"."cotizaciones" TO "anon";
GRANT ALL ON TABLE "finanzas_casadepiedra"."cotizaciones" TO "authenticated";
GRANT ALL ON TABLE "finanzas_casadepiedra"."cotizaciones" TO "service_role";



GRANT ALL ON TABLE "finanzas_casadepiedra"."espacios" TO "anon";
GRANT ALL ON TABLE "finanzas_casadepiedra"."espacios" TO "authenticated";
GRANT ALL ON TABLE "finanzas_casadepiedra"."espacios" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."espacios_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."espacios_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."espacios_id_seq" TO "service_role";



GRANT ALL ON TABLE "finanzas_casadepiedra"."impuestos" TO "anon";
GRANT ALL ON TABLE "finanzas_casadepiedra"."impuestos" TO "authenticated";
GRANT ALL ON TABLE "finanzas_casadepiedra"."impuestos" TO "service_role";



GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."impuestos_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."impuestos_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "finanzas_casadepiedra"."impuestos_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "postgres";
GRANT ALL ON TABLE "public"."profiles" TO "anon";
GRANT ALL ON TABLE "public"."profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."profiles" TO "service_role";





















ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































