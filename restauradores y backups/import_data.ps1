<#
.SYNOPSIS
    Importador de Datos para Producción (Marketing Hub / Cotizador)
    ¡CUIDADO! Inyecta datos en la base de datos activa.
#>

# ================= CONFIGURACIÓN =================

# 1. Nombre del contenedor de Base de Datos en PRODUCCIÓN
#    (Revisa con 'docker ps' en el servidor. Usualmente termina en '-db' o es el que usa la imagen postgres)
$ContainerName = "supabase_db_cotizador-server" 

# 2. Nombre del archivo a importar (Debe coincidir con el que traes de desarrollo)
$InputFile = ".\datos_produccion.sql"

# ================= PROCESO =================

$ScriptLocation = $PSScriptRoot
$SourcePath = Join-Path -Path $ScriptLocation -ChildPath $InputFile

Write-Host "==========================================" -ForegroundColor Red
Write-Host " IMPORTACION DE DATOS A PRODUCCION" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red
Write-Host "Archivo: $SourcePath"
Write-Host "Destino: Docker ($ContainerName)"
Write-Host "------------------------------------------"

# 1. Verificar que el archivo existe
if (!(Test-Path -Path $SourcePath)) {
    Write-Host "[ERROR] No encuentro el archivo '$InputFile'." -ForegroundColor Red
    Write-Host "Asegúrate de copiar el archivo .sql en esta misma carpeta." -ForegroundColor Yellow
    exit
}

# 2. Confirmación de Seguridad
$confirmation = Read-Host "¿Estás seguro de que quieres inyectar estos datos en PRODUCCIÓN? (S/N)"
if ($confirmation -ne 'S') {
    Write-Host "Operación cancelada." -ForegroundColor Yellow
    exit
}

try {
    Write-Host "Inyectando datos..." -NoNewline

    # Comando: Lee el archivo y lo envía al psql dentro del contenedor
    # Usamos cmd /c para manejar la tubería (|) correctamente entre Windows y Docker
    cmd /c "type ""$SourcePath"" | docker exec -i $ContainerName psql -U postgres -d postgres"

    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Datos importados exitosamente." -ForegroundColor Green
        Write-Host " Revisa tu aplicación para confirmar los cambios." -ForegroundColor Cyan
    } else {
        throw "Error al ejecutar psql"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host " Verifica que el contenedor '$ContainerName' esté corriendo." -ForegroundColor Yellow
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Red
Read-Host "Presiona Enter para salir"