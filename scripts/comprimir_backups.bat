@echo off
setlocal enabledelayedexpansion

:: Configuracion
set "BACKUP_PATH=C:\BackupsVentasBD2"
set "ZIP_PATH=C:\Program Files\7-Zip\7z.exe"
set "ZIP_OPTIONS=a -tzip -mx=9 -mmt=on"
set "DIAS_ANTIGUEDAD=3"

echo ========================================
echo  COMPRESION DE BACKUPS
echo ========================================
echo.
echo Ruta de busqueda: %BACKUP_PATH%\*.bak
echo Se comprimiran archivos con mas de %DIAS_ANTIGUEDAD% dias de antiguedad
echo.

:: Verificar si el directorio existe
if not exist "%BACKUP_PATH%" (
    echo [ERROR] El directorio de backups no existe: %BACKUP_PATH%
    goto :end
)

:: Verificar si 7-Zip esta instalado
if not exist "%ZIP_PATH%" (
    echo [ERROR] No se encontro 7-Zip en la ruta: %ZIP_PATH%
    echo Por favor, instale 7-Zip o actualice la ruta en el script.
    echo Puede descargarlo desde: https://www.7-zip.org/
    pause
    exit /b 1
)

:: Contadores para el resumen
set /a total_archivos=0
set /a archivos_comprimidos=0
set /a archivos_recientes=0

echo Listando archivos .bak...
echo ----------------------------------------

:: Primero mostramos todos los archivos .bak
for %%F in ("%BACKUP_PATH%\*.bak") do (
    if exist "%%F" (
        set /a total_archivos+=1
        echo [ARCHIVO %total_archivos%] %%~nxF - Creado el %%~tF
    )
)

echo.
echo Comprimiendo archivos con mas de %DIAS_ANTIGUEDAD% dias...
echo ----------------------------------------

:: Luego comprimimos solo los que tengan mas de X dias
for /f "delims=" %%F in ('forfiles /P "%BACKUP_PATH%" /M *.bak /D -%DIAS_ANTIGUEDAD% /C "cmd /c echo @path" 2^>nul') do (
    if exist "%%F" (
        echo [COMPRIMIENDO] %%~nxF - Creado el %%~tF
        
        "%ZIP_PATH%" %ZIP_OPTIONS% "%%~dpnF.zip" "%%F"
        
        if !ERRORLEVEL! EQU 0 (
            del /F /Q "%%F"
            set /a archivos_comprimidos+=1
            echo [COMPRIMIDO] %%~nxF
        ) else (
            echo [ERROR] No se pudo comprimir %%~nxF
        )
        echo ----------------------------------------
    )
)

:mostrar_resumen
echo.
echo ============ RESUMEN =================
echo Total de archivos .bak encontrados: !total_archivos!
echo Archivos comprimidos: !archivos_comprimidos!
echo ========================================
echo.
echo Proceso finalizado.
echo.

:end
echo Presione una tecla para continuar...
pause > nul