@echo off
setlocal enabledelayedexpansion

:: Configuración de la base de datos
set SQL_SERVER=DESKTOP-IU7D2D6\SQLEXPRESS
set DB_NAME=VentasBD2
set BACKUP_PATH=C:\BackupsVentasBD2

:: Crear directorio de respaldo si no existe
if not exist "%BACKUP_PATH%" mkdir "%BACKUP_PATH%"

:: Obtener fecha y hora en formato ISO 8601 usando PowerShell
for /f "delims=" %%a in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'"') do set "BACKUP_DATE=%%a"

:: Realizar el backup
echo Realizando backup de la base de datos %DB_NAME%...
sqlcmd -S %SQL_SERVER% -Q "BACKUP DATABASE [%DB_NAME%] TO DISK = '%BACKUP_PATH%\%DB_NAME%_backup_%BACKUP_DATE%.bak' WITH FORMAT, MEDIANAME = 'VentasBD2_Backups', NAME = 'Backup de %DB_NAME% del %BACKUP_DATE%';" -t 30 2>NUL

if %ERRORLEVEL% EQU 0 (
    set "BACKUP_FILE=%DB_NAME%_backup_%BACKUP_DATE%.bak"
    echo.
    echo [EXITO] Se creo el backup exitosamente: %BACKUP_FILE%
    echo Ubicacion: %BACKUP_PATH%\%BACKUP_FILE%
) else (
    echo.
    echo [ERROR] No se pudo completar el backup. Verifique los mensajes de error.
)

echo.
echo Presione una tecla para continuar...
pause > nul