# Sistema de Copias de Seguridad Automáticas

Este sistema implementa un mecanismo automatizado de copias de seguridad y limpieza de archivos antiguos para la base de datos VentasBD2.

## Características Principales

- Copias de seguridad automáticas diarias
- Limpieza automática de backups antiguos
- Sistema independiente del formato regional de fecha y hora
- Comprimido de backups antiguos para optimizar espacio
- Programación de tareas mediante Windows Task Scheduler

## Requisitos Previos

1. **SQL Server**
   - Base de datos VentasBD2 debe estar instalada y configurada
   
2. **7-Zip**
   - Debe estar instalado en: `C:\Program Files\7-Zip\7z.exe`
   - Se utiliza para comprimir los backups antiguos
   - Descargar desde: [7-Zip.org](https://www.7-zip.org/)
   
3. **Permisos de Sistema**
   - Permisos de administrador para crear tareas programadas
   - Permisos de escritura en la carpeta de backups

## Estructura de Carpetas

El sistema requiere las siguientes carpetas:

1. **Carpeta Principal de Scripts**
   ```
   C:\BackupsVentasBD2\scripts\
   └─── copiar_seguridad.bat
   └─── limpiar_antiguos.bat
   └─── programar_tareas.bat
   ```

2. **Carpeta de Backups**
   ```
   C:\BackupsVentasBD2\
   └─── backups_YYYY-MM-DD_HH-MM-SS.bak
   └─── backups_YYYY-MM-DD_HH-MM-SS.zip
   ```

## Instalación

1. **Instalar Requisitos**
   - Instalar SQL Server si no está instalado
   - Instalar 7-Zip desde [7-Zip.org](https://www.7-zip.org/)

2. **Crear Estructura de Carpetas**
   - La carpeta `C:\BackupsVentasBD2\` se creará automáticamente si no existe
   - La carpeta `scripts\` se creará automáticamente si no existe

3. **Configurar Tareas Programadas**
   - Ejecutar `programar_tareas.bat` como administrador
   - Se crearán dos tareas programadas:
     - `Copia_Seguridad_VentasBD2`: Ejecuta diariamente a media noche
     - `Limpieza_Antiguos_VentasBD2`: Ejecuta los lunes, miércoles y viernes a media noche

## Funcionamiento Automático

1. **Copia de Seguridad Diaria**
   - Se ejecuta automáticamente a media noche
   - Los backups se guardan con formato: `VentasBD2_backup_YYYY-MM-DD_HH-MM-SS.bak`
   - Los archivos se almacenan en `C:\BackupsVentasBD2\`

2. **Limpieza de Backups Antiguos**
   - Se ejecuta los lunes, miércoles y viernes a media noche
   - Backups antiguos (más de 15 días) se comprimen en .zip
   - Los backups comprimidos se mantienen por seguridad
   - Los backups originales se eliminan después de ser comprimidos

## Mantenimiento

1. **Verificación Periódica**
   - Verificar que las tareas programadas se ejecuten correctamente
   - Comprobar el espacio disponible en `C:\BackupsVentasBD2\`
   - Verificar que 7-Zip esté instalado y accesible

2. **Reparación de Problemas**
   - Si las tareas no se ejecutan:
     - Verificar permisos de administrador
     - Verificar que 7-Zip esté instalado correctamente
     - Ejecutar nuevamente `programar_tareas.bat` como administrador

## Notas Importantes

- El sistema crea automáticamente la carpeta de backups si no existe
- Los backups se mantienen en formato .bak mientras son recientes
- Los backups antiguos se comprimen en .zip para optimizar espacio
- Se recomienda mantener un respaldo físico adicional de los backups importantes
- El sistema es independiente del formato regional de fecha y hora de Windows