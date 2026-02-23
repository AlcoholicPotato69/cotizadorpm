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

if (-Not (Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] No encuentro el archivo sql." -ForegroundColor Red
    exit
}

$confirmation = Read-Host '¿Estas seguro de que quieres inyectar estos datos en PRODUCCION? (S/N)'
if ($confirmation -notmatch '^[sS]$') {
    Write-Host 'Operacion cancelada.' -ForegroundColor Yellow
    exit
}

# Pedimos la clave para poder ser supabase_admin y tener permisos de apagar triggers
Write-Host ""
$dbPassword = Read-Host "Ingresa la contrasena de la BD (POSTGRES_PASSWORD)" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

$env:PGPASSWORD = $plainPassword
Write-Host ""

try {
    Write-Host 'Inyectando datos con perfiles exactos... ' -NoNewline

    # Inyectamos usando supabase_admin
    $cmdStr = 'type "{0}" | docker exec -i -e PGPASSWORD {1} psql -U supabase_admin -d postgres' -f $SourcePath, $ContainerName
    cmd.exe /c $cmdStr

    if ($LASTEXITCODE -eq 0) {
        Write-Host '[OK]' -ForegroundColor Green
        Write-Host '------------------------------------------'
        Write-Host ' Datos y perfiles importados exitosamente.' -ForegroundColor Green
    } else {
        throw 'Error al inyectar. Verifica la contrasena.'
    }
}
catch {
    Write-Host '[ERROR]' -ForegroundColor Red
    Write-Host " Detalle: $_" -ForegroundColor Red
}
finally {
    $env:PGPASSWORD = $null
}

Write-Host '==========================================' -ForegroundColor Red
Pause