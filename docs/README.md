# Cotizador Local (Plaza Mayor)

Este repositorio contiene **solo lo necesario** para correr el Cotizador en un entorno **local / interno**, apuntando a **Supabase Local (Docker + Supabase CLI)**.

## Estructura

- `client/` Frontend (HTML/JS) del HUB + Cotizador (sin notificaciones).
- `server/sql/` SQL Maestro (esquema `finanzas` + compatibilidad de `profiles`).
- `server/supabase/migrations/` La misma migración lista para copiar a un proyecto `supabase init`.
- `docs/` Guías de instalación, extracción y operación.
- `scripts/` Comandos de ayuda (opcional).

## Inicio rápido (recomendado)

> Asumiendo que ya creaste tu carpeta del servidor local, por ejemplo `cotizador-server/`, con:
> `supabase init` y `supabase start`

1) Arranca tu Supabase local:
```bash
cd cotizador-server
supabase start
```

2) Copia el **API URL** y la **anon key** que imprime la terminal.

3) Edita:
- `client/js/hub-config.js`
y pega ahí `supabaseUrl` y `supabaseAnonKey`.

4) Crea la estructura del cotizador en tu Supabase local:

- Abre Studio (ej: `http://127.0.0.1:54323`)
- SQL Editor -> New query
- Ejecuta: `server/sql/finanzas_master.sql`

5) Abre `client/index.html` con Live Server.

