@echo off
:: Este archivo lanza el script de PowerShell en la misma carpeta
:: %~dp0 asegura que funcione aunque lo muevas de lugar (Ruta Relativa)

echo Iniciando respaldo del Cotizador / Marketing Hub...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0backup_storage.ps1"

:: El comando 'pause' mantiene la ventana abierta para que veas si hubo error o éxito
echo.
echo Proceso finalizado.
pause