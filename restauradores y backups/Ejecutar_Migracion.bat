@echo off
color 3f
echo ==================================================
echo   ACTUALIZACION DE ESTRUCTURA DE BASE DE DATOS
echo ==================================================
echo.
echo Se van a inyectar las nuevas columnas desde 'migracion.sql'
echo.

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0aplicar_migracion.ps1"

echo.
echo Proceso finalizado.