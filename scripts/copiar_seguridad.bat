@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo Sistema de Copias de Seguridad - VentasBD2
echo ==================================================
echo.

:: Configuración de la base de datos
echo Configurando parámetros de la base de datos...
set SQL_SERVER=DESKTOP-IU7D2D6\SQLEXPRESS
set DB_NAME=VentasBD2
set BACKUP_PATH="C:\BackupsVentasBD2"
echo.

echo Verificando existencia de la carpeta de backups...
:: Crear la carpeta de backups si no existe
if not exist !BACKUP_PATH! (
    echo Creando carpeta de backups en !BACKUP_PATH!
for /f "tokens=1-4 delims=/: " %%a in ('wmic os get localdatetime ^| find ".") do (
    set CURRENT_DATE=%%a
)
set BACKUP_DATE=!CURRENT_DATE:~0,4!-!CURRENT_DATE:~4,2!-!CURRENT_DATE:~6,2!_!CURRENT_DATE:~8,2!-!CURRENT_DATE:~10,2!-!CURRENT_DATE:~12,2!

sqlcmd -S %SQL_SERVER% -Q "BACKUP DATABASE [!DB_NAME!] TO DISK = 'C:\BackupsVentasBD2\!DB_NAME!_backup_!BACKUP_DATE!.bak' WITH FORMAT, MEDIANAME = 'VentasBD2_Backups', NAME = 'Backup de !DB_NAME! del !BACKUP_DATE!';" -t 30

if errorlevel 1 (
    echo ERROR: Fallo en la copia de seguridad
    echo Verifica que:
    echo - La base de datos VentasBD2 está accesible
    echo - Tienes permisos suficientes en SQL Server
    echo - La carpeta de backups tiene permisos de escritura
    echo.
    pause
    exit /b 1
)

echo Copia de seguridad completada exitosamente
echo Archivo de backup creado en: !BACKUP_FILE!
echo.
echo Presiona Enter para continuar...
pause
exit /b 0
