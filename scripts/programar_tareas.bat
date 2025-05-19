@echo off
setlocal enabledelayedexpansion

:: Configuración de las tareas programadas
set TASK_NAME_BACKUP=Copia_Seguridad_VentasBD2
set TASK_NAME_CLEANUP=Limpieza_Antiguos_VentasBD2
set SCRIPT_PATH="C:\BackupsVentasBD2"

:: Crear tarea para la copia de seguridad diaria a media noche
echo Creando tarea programada para copias de seguridad...
schtasks /create /tn !TASK_NAME_BACKUP! /tr "!SCRIPT_PATH!\copiar_seguridad.bat" /sc daily /st 00:00 /f

:: Crear tarea para la limpieza de backups antiguos
echo Creando tarea programada para limpieza de backups antiguos...
schtasks /create /tn !TASK_NAME_CLEANUP! /tr "!SCRIPT_PATH!\limpiar_antiguos.bat" /sc weekly /d MON,WED,FRI /st 00:00 /f

:: Verificar que las tareas se crearon correctamente
echo Verificando tareas programadas...
schtasks /query /tn !TASK_NAME_BACKUP!
schtasks /query /tn !TASK_NAME_CLEANUP!

echo Todas las tareas han sido configuradas exitosamente
exit /b 0
