<#
.SYNOPSIS
    Importador de Datos para Produccion (Marketing Hub / Cotizador)
#>

# ================= CONFIGURACION =================

$ContainerName = 'supabase_db_cotizador-server' 
$InputFile = 'datos_produccion.sql'

# ================= PROCESO =================

$ScriptLocation = $PSScriptRoot
$SourcePath = Join-Path -Path $ScriptLocation -ChildPath $InputFile

Write-Host '==========================================' -ForegroundColor Red
Write-Host ' IMPORTACION DE DATOS A PRODUCCION' -ForegroundColor Red
Write-Host '==========================================' -ForegroundColor Red
Write-Host "Archivo: $SourcePath"
Write-Host "Destino: Docker ($ContainerName)"
Write-Host '------------------------------------------'

# 1. Verificar que el archivo existe
if (-Not (Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] No encuentro el archivo sql." -ForegroundColor Red
    exit
}

# 2. Confirmacion de Seguridad
$confirmation = Read-Host '¿Estas seguro de que quieres inyectar estos datos en PRODUCCION? (S/N)'
if ($confirmation -notmatch '^[sS]$') {
    Write-Host 'Operacion cancelada.' -ForegroundColor Yellow
    exit
}

try {
    Write-Host 'Inyectando datos... ' -NoNewline

    # Construccion segura de la linea de comandos sin anidar comillas dobles
    $cmdStr = 'type "{0}" | docker exec -i {1} psql -U postgres -d postgres' -f $SourcePath, $ContainerName
    cmd.exe /c $cmdStr

    if ($LASTEXITCODE -eq 0) {
        Write-Host '[OK]' -ForegroundColor Green
        Write-Host '------------------------------------------'
        Write-Host ' Datos importados exitosamente.' -ForegroundColor Green
    } else {
        throw 'Error al ejecutar psql. Verifica que Docker este activo.'
    }
}
catch {
    Write-Host '[ERROR]' -ForegroundColor Red
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host '==========================================' -ForegroundColor Red

# Usamos Pause en lugar de Read-Host para evitar por completo el uso de comillas al final del archivo
Pause




