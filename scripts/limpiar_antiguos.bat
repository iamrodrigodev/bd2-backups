@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo Sistema de Limpieza de Backups Antiguos - VentasBD2
echo ==================================================
echo.

:: Configuración
echo Configurando parámetros del sistema...
set BACKUP_PATH="C:\BackupsVentasBD2"
set MAX_DAYS=15
echo.

echo Verificando existencia de la carpeta de backups...
if not exist !BACKUP_PATH! (
    echo ERROR: La carpeta de backups !BACKUP_PATH! no existe
    echo.
    echo Verifica que:
    echo - La carpeta de backups está creada
    echo - Tienes permisos de lectura/escritura en la carpeta
    echo.
    pause
    exit /b 1
)

echo.
:: Obtener fecha actual en formato ISO 8601 (independiente del formato regional)
echo Obteniendo fecha actual...
for /f "tokens=1-4 delims=/: " %%a in ('wmic os get localdatetime ^| find ".") do (
    set CURRENT_DATE=%%a
)
set TODAY=!CURRENT_DATE:~0,4!-!CURRENT_DATE:~4,2!-!CURRENT_DATE:~6,2!

:: Calcular fecha límite (hace 15 días)
echo Calculando fecha límite para backups antiguos...
set /a DAYS_TO_KEEP=15
set /a LIMIT_DATE=!CURRENT_DATE:~0,8! - !DAYS_TO_KEEP!
set LIMIT_DATE=!LIMIT_DATE:~0,4!-!LIMIT_DATE:~4,2!-!LIMIT_DATE:~6,2!

echo.
:: Buscar archivos antiguos
echo Buscando archivos antiguos en !BACKUP_PATH!...
for /f "delims=" %%f in ('dir /b !BACKUP_PATH!\*.bak') do (
    :: Obtener fecha de modificación del archivo
    for /f "tokens=1-2 delims=/ " %%a in ('dir /tc !BACKUP_PATH!\%%f ^| find "%%f"') do (
        set FILE_DATE=%%a
        set FILE_DATE=!FILE_DATE:~6,4!-!FILE_DATE:~0,2!-!FILE_DATE:~3,2!
        
        :: Comparar fechas
        if "!FILE_DATE!" lss "!LIMIT_DATE!" (
            echo Archivo antiguo encontrado: %%f (Fecha: !FILE_DATE!)
            echo.
            echo Comprimiendo archivo...
            
            :: Crear nombre para el archivo comprimido
            set ZIP_FILE=!BACKUP_PATH!\%%~nf.zip
            
            :: Comprimir usando 7-Zip
            "C:\Program Files\7-Zip\7z.exe" a -tzip "!ZIP_FILE!" "!BACKUP_PATH!\%%f"
            if errorlevel 1 (
                echo ERROR: Fallo al comprimir el archivo
                echo.
            ) else (
                echo Archivo comprimido exitosamente
                echo.
                echo Eliminando archivo original...
                del "!BACKUP_PATH!\%%f"
                if errorlevel 1 (
                    echo ERROR: No se pudo eliminar el archivo original
                    echo.
                ) else (
                    echo Archivo original eliminado
                    echo.
                )
            )
        )
    )
)

echo.
echo Proceso de limpieza completado
echo.
echo Presiona Enter para continuar...
pause
exit /b 0
