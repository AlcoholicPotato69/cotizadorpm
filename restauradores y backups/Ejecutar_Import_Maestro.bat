@echo off
color 5f
echo ========================================
echo   CLONACION DE SISTEMA (DEV -> PROD)
echo ========================================
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0import_master.ps1"
pause