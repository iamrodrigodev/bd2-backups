@echo off
setlocal enabledelayedexpansion

echo ==================================================
echo Sistema de Programación de Tareas - VentasBD2
echo ==================================================
echo.

:: Configuración de las tareas programadas
echo Configurando parámetros de las tareas...
set TASK_NAME_BACKUP=Copia_Seguridad_VentasBD2
set TASK_NAME_CLEANUP=Limpieza_Antiguos_VentasBD2
set SCRIPT_PATH="C:\BackupsVentasBD2"
echo.

echo Verificando existencia de la carpeta de scripts...
if not exist !SCRIPT_PATH! (
    echo ERROR: La carpeta de scripts !SCRIPT_PATH! no existe
    echo.
    echo Verifica que:
    echo - La carpeta de scripts está creada
    echo - Los scripts backup_simple.bat y limpiar_antiguos.bat están presentes
    echo.
    pause
    exit /b 1
)
echo.

echo Verificando existencia del script de backup...
if not exist "!SCRIPT_PATH!\backup_simple.bat" (
    echo ERROR: No se encontró el script de backup
    echo Verifica que el archivo backup_simple.bat existe en la carpeta scripts
    pause
    exit /b 1
)
echo.

echo Verificando existencia del script de limpieza...
if not exist "!SCRIPT_PATH!\limpiar_antiguos.bat" (
    echo ERROR: No se encontró el script de limpieza
    echo Verifica que el archivo limpiar_antiguos.bat existe en la carpeta scripts
    pause
    exit /b 1
)
echo.

echo Creando tareas programadas...

echo Creando tarea de backup semanal...
schtasks /create /tn !TASK_NAME_BACKUP! /tr "!SCRIPT_PATH!\backup_simple.bat" /sc weekly /d MON,WED,FRI /st 00:00 /f
if errorlevel 1 (
    echo ERROR: No se pudo crear la tarea de backup semanal
    echo Verifica que tienes permisos de administrador
    pause
    exit /b 1
)
echo.

echo Creando tarea de limpieza semanal...
schtasks /create /tn !TASK_NAME_CLEANUP! /tr "!SCRIPT_PATH!\limpiar_antiguos.bat" /sc weekly /d SAT /st 03:00 /f
if errorlevel 1 (
    echo ERROR: No se pudo crear la tarea de limpieza semanal
    echo Verifica que tienes permisos de administrador
    pause
    exit /b 1
)
echo.

echo Tareas programadas creadas exitosamente:
echo - Backup tres veces por semana (Lunes, Miércoles, Viernes) a la medianoche
echo - Limpieza semanal a las 3:00 AM los sábados
echo.

echo Resumen de las tareas programadas:
echo - Copia de seguridad semanal: Ejecuta los lunes, miércoles y viernes a media noche
echo - Limpieza de backups: Ejecuta los sábados a las 3:00 AM
echo.

echo Presiona Enter para continuar...
pause
exit /b 0
