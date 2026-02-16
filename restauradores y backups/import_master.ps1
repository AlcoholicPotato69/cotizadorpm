<#
.SYNOPSIS
    Importador MAESTRO a Producción
    ADVERTENCIA: Esto borra las tablas existentes y las recrea con los datos del backup.
#>

# ================= CONFIGURACIÓN =================
$ContainerName = "supabase_db_cotizador-server" 
$InputFile = ".\full_backup.sql"

# ================= PROCESO =================
$ScriptLocation = $PSScriptRoot
$SourcePath = Join-Path -Path $ScriptLocation -ChildPath $InputFile

Write-Host "==========================================" -ForegroundColor Magenta
Write-Host " RESTAURACION TOTAL (CLONACION)" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Magenta

if (!(Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] No encuentro '$InputFile'" -ForegroundColor Red
    exit
}

# Alerta de seguridad doble
Write-Host "ADVERTENCIA CRITICA:" -ForegroundColor Yellow
Write-Host "Este proceso BORRARA las tablas actuales en 'public' y 'finanzas'"
Write-Host "para reemplazarlas con la version del archivo."
$confirmation = Read-Host "Escribe 'CLONAR' para confirmar"

if ($confirmation -ne 'CLONAR') { exit }

try {
    Write-Host "Reconstruyendo base de datos..." -NoNewline
    
    # La importación es estándar, el archivo .sql ya trae las instrucciones de borrado (DROP) y creación (CREATE)
    cmd /c "type ""$SourcePath"" | docker exec -i $ContainerName psql -U postgres -d postgres"

    Write-Host " [COMPLETADO]" -ForegroundColor Green
}
catch {
    Write-Host " [ERROR]: $_" -ForegroundColor Red
}
Write-Host "==========================================" -ForegroundColor Magenta
Read-Host "Enter para salir"