<#
.SYNOPSIS
    Extractor de Datos (Data-Only) para Marketing Hub / Cotizador
    Autor: Johanpaz
#>

# ================= CONFIGURACION =================
$ContainerName = "supabase_db_cotizador-server" 
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

    # LA MAGIA AQUI: Agregamos --disable-triggers
    # Esto evita que se generen perfiles falsos ("user") al restaurar
    $DumpCommand = "pg_dump -U postgres -d postgres --data-only --column-inserts --disable-triggers --schema=auth --schema=public --schema=finanzas --schema=finanzas_casadepiedra"

    cmd /c "docker exec -i $ContainerName $DumpCommand > ""$FinalPath"""

    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Archivo generado exitosamente." -ForegroundColor Green
        Write-Host " Se respaldaron: Cotizaciones, Espacios, Usuarios y Permisos exactos." -ForegroundColor Cyan
    } else {
        throw "Error al ejecutar pg_dump"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host " Verifica que el contenedor '$ContainerName' este corriendo." -ForegroundColor Yellow
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Cyan
Pause