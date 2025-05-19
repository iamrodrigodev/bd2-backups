@echo off
setlocal enabledelayedexpansion

set SQL_SERVER=DESKTOP-IU7D2D6\SQLEXPRESS
set DB_NAME=VentasBD2
set BACKUP_PATH=C:\BackupsVentasBD2

for /f "tokens=1-4 delims=/: " %%a in ('wmic os get localdatetime ^| find "."') do (
    set CURRENT_DATE=%%a
)
set BACKUP_DATE=!CURRENT_DATE:~0,4!-!CURRENT_DATE:~4,2!-!CURRENT_DATE:~6,2!_!CURRENT_DATE:~8,2!-!CURRENT_DATE:~10,2!-!CURRENT_DATE:~12,2!

sqlcmd -S %SQL_SERVER% -Q "BACKUP DATABASE [!DB_NAME!] TO DISK = 'C:\BackupsVentasBD2\!DB_NAME!_backup_!BACKUP_DATE!.bak' WITH FORMAT, MEDIANAME = 'VentasBD2_Backups', NAME = 'Backup de !DB_NAME! del !BACKUP_DATE!';" -t 30 2>NUL

set BACKUP_FILE=!DB_NAME!_backup_!BACKUP_DATE!.bak
echo Se creo el backup exitosamente: !BACKUP_FILE!
pause