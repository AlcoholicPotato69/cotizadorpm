@echo off
:: Launcher para Restaurar Storage (Marketing Hub / Cotizador)
:: Ejecuta el script de PowerShell restore_storage.ps1 ubicado en la misma carpeta
:: %~dp0 asegura que funcione aunque muevas la carpeta de lugar

color 4f
:: (El color 4f pone fondo rojo y letras blancas para indicar PRECAUCION)

echo ==================================================
echo   ATENCION: MODO DE RESTAURACION (INVERSO)
echo ==================================================
echo.
echo Vas a enviar archivos de tu PC al Servidor Docker.
echo Esto SOBRESCRIBIRA los archivos existentes en el servidor.
echo.

:: Ejecuta el script permitiendo la interacción (para que puedas responder S/N)
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0restore_backup.ps1"

echo.
echo Proceso finalizado.
pause