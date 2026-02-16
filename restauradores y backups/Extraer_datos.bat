@echo off
:: Launcher para Extraer Datos
echo Generando archivo SQL de datos...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0extract_data.ps1"

echo.
echo Si ves [OK] arriba, el archivo datos_produccion.sql esta listo.
pause