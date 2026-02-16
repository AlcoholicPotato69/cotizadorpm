@echo off
echo Creando copia total del sistema...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0export_master.ps1"
pause