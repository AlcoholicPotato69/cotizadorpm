<#
.SYNOPSIS
    Extractor de Datos (Data-Only) para Marketing Hub / Cotizador
    Autor: Johanpaz
    Nota: Ahora incluye respaldos de usuarios y contraseñas (esquema auth).
#>

# ================= CONFIGURACIÓN =================

# 1. Nombre del contenedor de Base de Datos en DESARROLLO
#    (Usualmente es 'supabase_db_cotizador' o similar. Revisa con 'docker ps')
$ContainerName = "supabase_db_cotizador-server" 

# 2. Nombre del archivo de salida
$OutputFile = ".\datos_produccion.sql"

# ================= PROCESO =================

$ScriptLocation = $PSScriptRoot
$FinalPath = Join-Path -Path $ScriptLocation -ChildPath $OutputFile

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " EXTRACCION DE DATOS (INCLUYE USUARIOS)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Origen: Docker ($ContainerName)"
Write-Host "Destino: $FinalPath"
Write-Host "------------------------------------------"

try {
    Write-Host "Extrayendo datos de Auth, Public y Finanzas... " -NoNewline

    # El comando mágico: --data-only evita que se borren las tablas en producción
    # --column-inserts asegura máxima compatibilidad
    # SE AGREGÓ --schema=auth PARA RESPALDAR CORREOS Y CONTRASEÑAS ENCRIPTADAS
    $DumpCommand = "pg_dump -U postgres -d postgres --data-only --column-inserts --schema=auth --schema=public --schema=finanzas --schema=finanzas_casadepiedra"

    # Ejecutamos docker y capturamos la salida en el archivo con codificación UTF8
    # Usamos cmd /c para evitar problemas de piping en PowerShell con binarios de linux
    cmd /c "docker exec -i $ContainerName $DumpCommand > ""$FinalPath"""

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Archivo generado exitosamente." -ForegroundColor Green
        Write-Host " Se respaldaron: Cotizaciones, Espacios, Usuarios y Permisos." -ForegroundColor Cyan
        Write-Host " Ahora puedes llevar '$OutputFile' a tu servidor." -ForegroundColor Gray
    } else {
        throw "Error al ejecutar pg_dump"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host " Verifica que el contenedor '$ContainerName' esté corriendo." -ForegroundColor Yellow
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Cyan