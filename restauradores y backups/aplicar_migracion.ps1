<#
.SYNOPSIS
    Ejecutor de Migraciones SQL para Produccion
#>

$ContainerName = 'supabase_db_cotizador-server' 
$InputFile = 'migracion.sql'
$ScriptLocation = $PSScriptRoot
$SourcePath = Join-Path -Path $ScriptLocation -ChildPath $InputFile

Write-Host '==========================================' -ForegroundColor Cyan
Write-Host ' APLICANDO CAMBIOS DE ESTRUCTURA (MIGRACION)' -ForegroundColor Cyan
Write-Host '==========================================' -ForegroundColor Cyan
Write-Host "Archivo: $SourcePath"

if (-Not (Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] No encuentro el archivo migracion.sql." -ForegroundColor Red
    exit
}

Write-Host 'Inyectando cambios... ' -NoNewline
try {
    $cmdStr = 'type "{0}" | docker exec -i {1} psql -U postgres -d postgres' -f $SourcePath, $ContainerName
    cmd.exe /c $cmdStr

    if ($LASTEXITCODE -eq 0) {
        Write-Host '[OK]' -ForegroundColor Green
        Write-Host 'Nuevas columnas y cambios aplicados con exito.' -ForegroundColor Green
    } else {
        throw 'Fallo la inyeccion. Verifica que Docker este corriendo.'
    }
}
catch {
    Write-Host '[ERROR]' -ForegroundColor Red
    Write-Host $_ -ForegroundColor Red
}

Write-Host '==========================================' -ForegroundColor Cyan
Pause