@echo off
setlocal enabledelayedexpansion

:: Configuración
set "BACKUP_PATH=C:\BackupsVentasBD2"
set "DIAS_A_MANTENER=15"
set "EXTENSION=*.bak"

echo ========================================
echo  Limpieza de Backups Antiguos
echo ========================================
echo.
echo Ruta de busqueda: %BACKUP_PATH%\%EXTENSION%
echo Se eliminaran archivos con mas de %DIAS_A_MANTENER% dias de antiguedad
echo.

:: Verificar si el directorio existe
if not exist "%BACKUP_PATH%" (
    echo [ERROR] El directorio de backups no existe: %BACKUP_PATH%
    goto :end
)

:: Contadores para el resumen
set /a total_archivos=0
set /a archivos_eliminados=0
set /a archivos_mantenidos=0

echo Buscando archivos de backup...
echo ----------------------------------------

:: Usar forfiles para encontrar y eliminar archivos antiguos
for /f "delims=" %%F in ('forfiles /P "%BACKUP_PATH%" /M %EXTENSION% /D -%DIAS_A_MANTENER% /C "cmd /c echo @path" 2^>nul') do (
    if exist "%%F" (
        echo [ELIMINANDO] "%%~nxF" - Creado el %%~tF
        del /F /Q "%%F"
        if !ERRORLEVEL! EQU 0 (
            set /a archivos_eliminados+=1
            echo [ELIMINADO] "%%~nxF"
        ) else (
            echo [ERROR] No se pudo eliminar "%%~nxF"
        )
        echo ----------------------------------------
    )
)

:: Contar archivos restantes
for /f "delims=" %%F in ('dir /a-d /b "%BACKUP_PATH%\%EXTENSION%" 2^>nul') do (
    set /a total_archivos+=1
)

set /a archivos_mantenidos=!total_archivos! - !archivos_eliminados!

:: Mostrar resumen
echo.
echo ============ RESUMEN =================
echo Total de archivos encontrados: !total_archivos!
echo Archivos eliminados: !archivos_eliminados!
echo Archivos mantenidos: !archivos_mantenidos!
echo ========================================
echo.
echo Limpieza completada.
echo Presione una tecla para continuar...
pause > nul

:end