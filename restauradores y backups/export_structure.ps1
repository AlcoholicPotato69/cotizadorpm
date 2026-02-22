<#
.SYNOPSIS
    Exportador de ESTRUCTURA (Schema-Only) - Cotizador / Marketing Hub
    Autor: Johan / Gemini Assistant
#>

# ================= CONFIGURACIÓN =================

# Nombre del contenedor en DESARROLLO
$ContainerName = "supabase_db_cotizador-server" 

# Nombre del archivo de salida
$OutputFile = ".\estructura_produccion.sql"

# Esquemas a exportar (Añade o quita según necesites)
$Schemas = "--schema=public --schema=finanzas --schema=storage --schema=finanzas_casadepiedra"

# ================= PROCESO =================

$ScriptLocation = $PSScriptRoot
$FinalPath = Join-Path -Path $ScriptLocation -ChildPath $OutputFile

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " EXTRACCION DE ESTRUCTURA (SIN DATOS)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Origen: Docker ($ContainerName)"
Write-Host "Destino: $FinalPath"
Write-Host "------------------------------------------"

try {
    Write-Host "Generando radiografía del sistema..." -NoNewline

    # --schema-only: La clave para no traer datos
    # --no-owner --no-privileges: Limpia el código de usuarios específicos de tu PC local
    $DumpCommand = "pg_dump -U postgres -d postgres --schema-only $Schemas --no-owner --no-privileges"

    cmd /c "docker exec -i $ContainerName $DumpCommand > ""$FinalPath"""

    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Archivo de estructura listo." -ForegroundColor Green
    } else {
        throw "Error al ejecutar pg_dump"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Cyan