<#
.SYNOPSIS
    Importador de ESTRUCTURA a Producción
#>

# ================= CONFIGURACIÓN =================

# Nombre del contenedor en PRODUCCIÓN
$ContainerName = "supabase_db_cotizador-server" 

# Archivo a leer
$InputFile = ".\estructura_produccion.sql"

# ================= PROCESO =================

$ScriptLocation = $PSScriptRoot
$SourcePath = Join-Path -Path $ScriptLocation -ChildPath $InputFile

Write-Host "==========================================" -ForegroundColor Magenta
Write-Host " CARGA DE ESTRUCTURA (SCHEMA)" -ForegroundColor Magenta
Write-Host "==========================================" -ForegroundColor Magenta
Write-Host "Archivo: $InputFile"
Write-Host "------------------------------------------"

if (!(Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] Falta el archivo .sql" -ForegroundColor Red
    exit
}

$confirmation = Read-Host "¿Confirmas aplicar estos cambios de estructura al servidor? (S/N)"
if ($confirmation -ne 'S') { exit }

try {
    Write-Host "Aplicando esquema..." -NoNewline

    # Usamos psql simple. Si una tabla ya existe, dará un error inofensivo y continuará.
    cmd /c "type ""$SourcePath"" | docker exec -i $ContainerName psql -U postgres -d postgres"

    Write-Host " [PROCESO FINALIZADO]" -ForegroundColor Green
    Write-Host " Nota: Si viste errores de 'relation already exists', es normal en actualizaciones." -ForegroundColor Yellow
}
catch {
    Write-Host " [ERROR CRITICO]: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Magenta
Read-Host "Enter para salir"