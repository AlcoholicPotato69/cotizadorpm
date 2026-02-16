<#
.SYNOPSIS
    Script de Sincronización (Espejo) para Supabase Storage
    Proyecto: Cotizador / Marketing Hub
    
.DESCRIPTION
    Copia el contenido actual del contenedor de Storage a una carpeta local.
    Sobrescribe archivos modificados y añade los nuevos.
    NO genera historial de versiones por fecha (siempre tendrás la última versión).
#>

# ================= CONFIGURACIÓN PERSONALIZABLE =================

# 1. Nombre EXACTO del contenedor (Verificar con 'docker ps')
$ContainerName = "supabase_storage_cotizador-server" 

# 2. Ruta interna de Docker (No cambiar)
$InternalPath = "/mnt/stub/stub"

# 3. RUTA DE DESTINO (Relativa)
#    "." = Misma carpeta donde está el script.
#    ".." = Una carpeta atrás.
#    Ejemplo: "..\OneDrive\Backups_Cotizador"
$RelativeTargetDir = ".\Storage_Live_Mirror"

# ================= EJECUCIÓN DEL PROCESO =================

# Convertir ruta relativa a absoluta para evitar errores de Docker
$ScriptLocation = $PSScriptRoot
$FinalDest = Join-Path -Path $ScriptLocation -ChildPath $RelativeTargetDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " SINCRONIZANDO STORAGE (MODO ESPEJO)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Origen: Docker ($ContainerName)"
Write-Host "Destino: $FinalDest"
Write-Host "------------------------------------------"

# 1. Crear el directorio base si no existe
if (!(Test-Path -Path $FinalDest)) {
    New-Item -ItemType Directory -Force -Path $FinalDest | Out-Null
    Write-Host "[INFO] Carpeta de destino creada." -ForegroundColor Yellow
}

# 2. Ejecutar la copia (Docker CP sobrescribe por defecto)
try {
    Write-Host "Copiando archivos nuevos y actualizados..." -NoNewline
    
    # El comando copia todo el contenido del volumen a la carpeta destino.
    # Si el archivo ya existe y es diferente, Docker lo reemplaza.
    docker cp "${ContainerName}:${InternalPath}/." "$FinalDest"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Sincronización completada." -ForegroundColor Green
        Write-Host " Los archivos en '$RelativeTargetDir' son idénticos al servidor." -ForegroundColor Gray
    } else {
        throw "Error al ejecutar docker cp"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host "------------------------------------------"
    Write-Host " Falló la sincronización. Verifica:" -ForegroundColor Yellow
    Write-Host " 1. Que el contenedor '$ContainerName' esté encendido."
    Write-Host " 2. Que tengas permisos de escritura en la carpeta destino."
    Write-Host " Detalle: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Cyan
# Pausa opcional para ver el resultado si lo ejecutas con doble clic
# Read-Host "Presiona Enter para salir"