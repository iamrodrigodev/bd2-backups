@echo off
setlocal enabledelayedexpansion

:: Configuración de la base de datos
set DB_NAME=VentasBD2
set BACKUP_PATH="C:\BackupsVentasBD2"

:: Crear la carpeta de backups si no existe
if not exist !BACKUP_PATH! mkdir !BACKUP_PATH!

:: Obtener fecha y hora en formato ISO 8601 (independiente del formato regional)
for /f "tokens=1-4 delims=/: " %%a in ('wmic os get localdatetime ^| find "."') do (
    set CURRENT_DATE=%%a
)
set BACKUP_DATE=!CURRENT_DATE:~0,4!-!CURRENT_DATE:~4,2!-!CURRENT_DATE:~6,2!_!CURRENT_DATE:~8,2!-!CURRENT_DATE:~10,2!-!CURRENT_DATE:~12,2!

:: Crear el nombre del archivo de backup
set BACKUP_FILE=!BACKUP_PATH!\!DB_NAME!_backup_!BACKUP_DATE!.bak

:: Realizar la copia de seguridad
echo Iniciando copia de seguridad de !DB_NAME!...
sqlcmd -Q "BACKUP DATABASE [!DB_NAME!] TO DISK = '!BACKUP_FILE!' WITH FORMAT, MEDIANAME = 'VentasBD2_Backups', NAME = 'Backup de !DB_NAME! del !BACKUP_DATE!';"

if errorlevel 1 (
    echo ERROR: Fallo en la copia de seguridad
    exit /b 1
)

echo Copia de seguridad completada exitosamente
exit /b 0
