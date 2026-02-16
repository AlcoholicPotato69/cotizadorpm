@echo off
echo Generando SQL de Estructura...
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0export_structure.ps1"
echo.
pause