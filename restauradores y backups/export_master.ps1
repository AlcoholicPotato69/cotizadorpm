<#
.SYNOPSIS
    Exportador MAESTRO (Estructura + Datos)
    Genera un clon completo de los esquemas public y finanzas.
#>

# ================= CONFIGURACIÓN =================
$ContainerName = "supabase_db_cotizador-server " 
$OutputFile = ".\full_backup.sql"
$Schemas = "--schema=public --schema=finanzas --schema=finanzas_casadepiedra"

# ================= PROCESO =================
$ScriptLocation = $PSScriptRoot
$FinalPath = Join-Path -Path $ScriptLocation -ChildPath $OutputFile

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " GENERANDO SNAPSHOT COMPLETO DEL SISTEMA" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

try {
    Write-Host "Exportando Estructura y Datos..." -NoNewline

    # AL QUITAR '--data-only' y '--schema-only', pg_dump exporta TODO por defecto.
    # --clean --if-exists: Añade comandos para borrar las tablas viejas antes de crear las nuevas (ideal para clonar).
    $DumpCommand = "pg_dump -U postgres -d postgres $Schemas --clean --if-exists --column-inserts --no-owner --no-privileges"

    cmd /c "docker exec -i $ContainerName $DumpCommand > ""$FinalPath"""

    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        Write-Host " Archivo '$OutputFile' generado." -ForegroundColor Gray
    } else { throw "Error en pg_dump" }
}
catch {
    Write-Host " [ERROR]: $_" -ForegroundColor Red
}
Write-Host "==========================================" -ForegroundColor Cyan