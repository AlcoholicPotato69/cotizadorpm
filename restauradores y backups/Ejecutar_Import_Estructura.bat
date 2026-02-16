@echo off
color 5f
echo ==================================================
echo   ACTUALIZACION DE ESTRUCTURA (SERIE MAGENTA)
echo ==================================================
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0import_structure.ps1"
echo.
pause