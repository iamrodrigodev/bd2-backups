@echo off
setlocal enabledelayedexpansion

:: Configuración
set "BACKUP_PATH=C:\BackupsVentasBD2"
set "DIAS_A_MANTENER=15"
set "EXTENSIONES=*.bak *.zip"

echo ========================================
echo  LIMPIEZA DE BACKUPS ANTIGUOS
echo ========================================
echo.
echo Ruta de busqueda: %BACKUP_PATH%
echo Extensiones: %EXTENSIONES%
echo Se eliminaran archivos con mas de %DIAS_A_MANTENER% dias de antiguedad
echo.

:: Verificar si el directorio existe
if not exist "%BACKUP_PATH%" (
    echo [ERROR] El directorio de backups no existe: %BACKUP_PATH%
    goto :end
)

:: Inicializar contadores
set /a total_archivos=0
set /a archivos_eliminados=0
set /a archivos_mantenidos=0

echo Buscando archivos de backup...
echo ----------------------------------------

:: Procesar cada extensión
for %%E in (%EXTENSIONES%) do (
    echo.
    echo Procesando archivos: %%E
    echo ----------------------------------------
    
    for /f "delims=" %%F in ('forfiles /P "%BACKUP_PATH%" /M "%%E" /D -%DIAS_A_MANTENER% /C "cmd /c echo @path" 2^>nul') do (
        if exist "%%F" (
            echo [ELIMINANDO] "%%~nxF" - Creado el %%~tF
            del /F /Q "%%F"
            if !ERRORLEVEL! EQU 0 (
                set /a archivos_eliminados+=1
                echo [ELIMINADO] "%%~nxF"
            ) else (
                echo [ERROR] No se pudo eliminar "%%~nxF"
            )
            set /a total_archivos+=1
            echo ----------------------------------------
        )
    )
)

:: Contar archivos restantes
for /f "tokens=*" %%E in ('echo %EXTENSIONES%') do (
    for /f "delims=" %%F in ('dir /a-d /b "%BACKUP_PATH%\%%E" 2^>nul') do (
        set /a archivos_mantenidos+=1
    )
)

:mostrar_resumen
echo.
echo ============ RESUMEN =================
echo Total de archivos encontrados: %total_archivos%
echo Archivos eliminados: %archivos_eliminados%
echo Archivos mantenidos: %archivos_mantenidos%
echo ========================================
echo.
echo Proceso de limpieza finalizado.
echo.

:end
echo Presione una tecla para continuar...
pause > nul