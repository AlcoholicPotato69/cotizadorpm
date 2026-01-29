# 02 - Extraer esquema/datos desde Supabase (nube) con Supabase CLI

> Esto sirve si quieres clonar *exactamente* lo que ya está en producción (estructura + datos).

## Vincular proyecto (opcional, recomendado)
En un folder temporal:

```bash
supabase login
supabase link --project-ref TU_PROJECT_REF
```

## Traer estructura (migraciones)
```bash
supabase db pull
```

## Dump de datos del esquema finanzas
```bash
supabase db dump --data-only --schema finanzas > finanzas_data.sql
```

Luego, en tu Supabase local (Studio -> SQL Editor), corre ese `finanzas_data.sql`.
