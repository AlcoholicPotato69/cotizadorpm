# 01 - Correr Supabase Local (Docker + Supabase CLI)

## Requisitos
- Docker Desktop (Windows)
- Supabase CLI (`npm i -g supabase`)

## Crear servidor local (una vez)

```bash
mkdir cotizador-server
cd cotizador-server
supabase init
```

## Arranque
En `cotizador-server/`:

```bash
supabase start
```

Te mostrará:
- API URL (ej: http://127.0.0.1:54321)
- anon key (eyJhbGciOi...)

Copia ambos y pégalos en `client/js/hub-config.js`.

## Inyectar el SQL Maestro
En tu Studio local (`http://127.0.0.1:54323`):
- SQL Editor -> New query
- Copia y pega `server/sql/finanzas_master.sql`
- Run

## Apagar
```bash
supabase stop
```
