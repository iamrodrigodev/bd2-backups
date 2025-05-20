@echo off
setlocal enabledelayedexpansion

:: Configuracion
set "BACKUP_PATH=C:\BackupsVentasBD2"
set "DIAS_A_COMPRIMIR=3"
set "EXTENSION=*.bak"
set "ZIP_PATH=\"C:\Program Files\7-Zip\7z.exe\""
set "ZIP_OPTIONS=a -tzip -mx=9 -mmt=on"

echo ========================================
echo  COMPRESION DE BACKUPS ANTIGUOS
echo ========================================
echo.
echo Ruta de busqueda: %BACKUP_PATH%\%EXTENSION%
echo Se comprimiran archivos con mas de %DIAS_A_COMPRIMIR% dias de antiguedad
echo.

:: Verificar si el directorio existe
if not exist "%BACKUP_PATH%" (
    echo [ERROR] El directorio de backups no existe: %BACKUP_PATH%
    goto :end
)

:: Verificar si 7-Zip esta instalado
if not exist %ZIP_PATH% (
    echo [ERROR] No se encontro 7-Zip en la ruta: %ZIP_PATH%
    echo Por favor, instale 7-Zip o actualice la ruta en el script.
    echo Puede descargarlo desde: https://www.7-zip.org/
    goto :end
)

:: Contadores para el resumen
set /a total_archivos=0
set /a archivos_comprimidos=0
set /a archivos_mantenidos=0

echo Buscando archivos de backup para comprimir...
echo ----------------------------------------

:: Usar forfiles para encontrar archivos antiguos
for /f "delims=" %%F in ('forfiles /P "%BACKUP_PATH%" /M %EXTENSION% /D -%DIAS_A_COMPRIMIR% /C "cmd /c echo @path" 2^>nul') do (
    if exist "%%F" (
        set "archivo=%%~nF"
        set "archivo_sin_ext=!archivo:~0,-4!"
        
        :: Verificar si el archivo ya esta comprimido
        if not exist "%%~dpF!archivo_sin_ext!.zip" (
            echo [COMPRIMIENDO] "%%~nxF" - Creado el %%~tF
            
            :: Comprimir el archivo con 7-Zip
            %ZIP_PATH% %ZIP_OPTIONS% "%%~dpF!archivo_sin_ext!.zip" "%%F"
            
            if !ERRORLEVEL! EQU 0 (
                :: Eliminar el archivo original si la compresion fue exitosa
                del /F /Q "%%F"
                set /a archivos_comprimidos+=1
                echo [COMPRIMIDO] "%%~nxF" -> "!archivo_sin_ext!.zip"
            ) else (
                echo [ERROR] No se pudo comprimir "%%~nxF"
            )
        ) else (
            echo [OMITIDO] "%%~nxF" ya tiene un archivo .zip correspondiente
            set /a archivos_mantenidos+=1
        )
        set /a total_archivos+=1
        echo ----------------------------------------
    )
)

:mostrar_resumen
echo.
echo ============ RESUMEN =================
echo Total de archivos encontrados: %total_archivos%
echo Archivos comprimidos: %archivos_comprimidos%
echo Archivos ya comprimidos: %archivos_mantenidos%
echo ========================================
echo.
echo Proceso de compresion finalizado.
echo.

:end
echo Presione una tecla para continuar...
pause > nul