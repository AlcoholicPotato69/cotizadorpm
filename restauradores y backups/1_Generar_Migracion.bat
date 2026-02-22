@echo off
color 2f
echo ==================================================
echo   DETECTAR CAMBIOS EN LA BD LOCAL (SUPABASE DIFF)
echo ==================================================
echo.
echo Analizando tu entorno de desarrollo local...
echo Supabase esta escribiendo el codigo SQL automaticamente.
echo.

:: El comando diff compara tu base de datos y guarda el resultado en el archivo
supabase db diff --schema finanzas,finanzas_casadepiedra > migracion.sql

echo.
echo [OK] Cambios detectados y guardados en 'migracion.sql'.
echo.
pause