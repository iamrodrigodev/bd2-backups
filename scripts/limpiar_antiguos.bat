@echo off
setlocal enabledelayedexpansion

:: Configuración
set BACKUP_PATH="C:\BackupsVentasBD2"
set MAX_DAYS=15

:: Obtener fecha actual en formato ISO 8601
for /f "tokens=1-4 delims=/: " %%a in ('wmic os get localdatetime ^| find "."') do (
    set CURRENT_DATE=%%a
)

:: Convertir fecha actual a segundos desde 1970
set /a CURRENT_SECONDS=!CURRENT_DATE:~0,4!*31536000 + !CURRENT_DATE:~4,2!*2678400 + !CURRENT_DATE:~6,2!*86400 + !CURRENT_DATE:~8,2!*3600 + !CURRENT_DATE:~10,2!*60 + !CURRENT_DATE:~12,2!

:: Limpiar backups antiguos
echo Iniciando limpieza de backups antiguos...
for %%f in (!BACKUP_PATH!\*.bak) do (
    :: Obtener fecha de creación del archivo
    for /f "tokens=1-4 delims=/: " %%a in ('wmic datafile where "name='%%~ff'" get creationdate ^| find "."') do (
        set FILE_DATE=%%a
    )

    :: Convertir fecha del archivo a segundos desde 1970
    set /a FILE_SECONDS=!FILE_DATE:~0,4!*31536000 + !FILE_DATE:~4,2!*2678400 + !FILE_DATE:~6,2!*86400 + !FILE_DATE:~8,2!*3600 + !FILE_DATE:~10,2!*60 + !FILE_DATE:~12,2!

    :: Calcular diferencia en días
    set /a DIFF_DAYS=(!CURRENT_SECONDS! - !FILE_SECONDS!) / 86400

    :: Si el archivo es más antiguo que MAX_DAYS, comprimirlo
    if !DIFF_DAYS! gtr !MAX_DAYS! (
        echo Comprimiendo %%~ff...
        "C:\Program Files\7-Zip\7z.exe" a -tzip "%%~dpnxf.zip" "%%~ff"
        if errorlevel 1 (
            echo ERROR: Fallo al comprimir %%~ff
        ) else (
            echo Eliminando %%~ff...
            del "%%~ff"
        )
    )
)

echo Limpieza completada
exit /b 0
