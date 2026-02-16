@echo off
:: Launcher para Importar Datos
color 4f
echo ==================================================
echo   PRECAUCION: ESTAS EN EL SERVIDOR DE PRODUCCION
echo ==================================================
echo.
echo Vas a cargar datos desde 'datos_produccion.sql'.
echo.

PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0import_data.ps1"

echo.
echo Proceso finalizado.
pause