<#
.SYNOPSIS
    Script de RESTAURACIÓN para Supabase Storage (CORREGIDO)
    ¡CUIDADO! Esto sobrescribe lo que haya en el servidor con tu copia local.
#>

# ================= CONFIGURACIÓN =================

# 1. Nombre del contenedor
$ContainerName = "supabase_storage_cotizador-server" 

# 2. Ruta interna (LA QUE ENCONTRAMOS CON EL DETECTIVE)
$InternalPath = "/mnt/stub/stub"

# 3. Ruta de tu Copia de Seguridad (Relativa)
$BackupSource = ".\Storage_Live_Mirror"

# ================= LÓGICA DE RESTAURACIÓN =================

$ScriptLocation = $PSScriptRoot
$SourceAbsPath = Join-Path -Path $ScriptLocation -ChildPath $BackupSource

Write-Host "==========================================" -ForegroundColor Red
Write-Host " ALERTA: RESTAURANDO STORAGE A PRODUCCION" -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Red
# CORRECCIÓN AQUÍ: Usamos ${} para que PowerShell entienda dónde termina la variable
Write-Host "Origen (Tu PC): $SourceAbsPath"
Write-Host "Destino (Docker): ${ContainerName}:${InternalPath}"
Write-Host "------------------------------------------"

# Verificación de seguridad básica
if (!(Test-Path -Path $SourceAbsPath)) {
    Write-Host "[ERROR] No encuentro la carpeta de respaldo." -ForegroundColor Red
    exit
}

# Preguntar confirmación para evitar accidentes
$confirmation = Read-Host "¿Estás seguro de que quieres inyectar estos archivos al servidor? (S/N)"
if ($confirmation -ne 'S') {
    Write-Host "Operación cancelada." -ForegroundColor Yellow
    exit
}

try {
    Write-Host "Inyectando archivos..." -NoNewline
    
    # CORRECCIÓN AQUÍ TAMBIÉN: Aseguramos las rutas con comillas y llaves
    docker cp "${SourceAbsPath}/." "${ContainerName}:${InternalPath}/"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK]" -ForegroundColor Green
        Write-Host "------------------------------------------"
        Write-Host " Restauración completada." -ForegroundColor Green
        Write-Host " Reiniciando contenedor de Storage para aplicar cambios..."
        
        docker restart $ContainerName
        
        Write-Host " ¡Listo! Tus archivos han vuelto a la vida." -ForegroundColor Cyan
    } else {
        throw "Error al ejecutar docker cp"
    }
}
catch {
    Write-Host " [ERROR]" -ForegroundColor Red
    Write-Host " Detalles: $_" -ForegroundColor Red
}

Write-Host "==========================================" -ForegroundColor Red
Read-Host "Presiona Enter para salir"