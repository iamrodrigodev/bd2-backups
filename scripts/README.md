# Scripts del Sistema de Copias de Seguridad

Este directorio contiene los scripts batch (.bat) que implementan el sistema de copias de seguridad y limpieza de backups.

## Scripts Disponibles

### 1. backup_simple.bat
- **Propósito**: Realiza una copia de seguridad de la base de datos VentasBD2
- **Funcionalidades**:
  - Conecta a SQL Server usando el servidor DESKTOP-IU7D2D6\SQLEXPRESS
  - Genera un nombre de archivo con fecha y hora actual
  - Crea un backup en formato .bak
  - No requiere interacción del usuario
- **Uso**: Ejecutar directamente desde línea de comandos

### 2. programar_tareas.bat
- **Propósito**: Configura las tareas programadas para backups y limpieza
- **Funcionalidades**:
  - Verifica la existencia de los scripts necesarios
  - Crea dos tareas programadas:
    - Backup VentasBD2: Ejecuta los lunes, miércoles y viernes a la medianoche
    - Limpieza Antiguos Backups: Ejecuta los sábados a las 3:00 AM
  - Requiere permisos de administrador
- **Uso**: Ejecutar como administrador para crear las tareas programadas

### 3. limpiar_antiguos.bat
- **Propósito**: Limpia los backups antiguos y los comprime
- **Funcionalidades**:
  - Busca archivos .bak con más de 15 días de antigüedad
  - Comprime los archivos antiguos en formato .zip
  - Elimina los archivos .bak originales después de la compresión
  - Usa 7-Zip para la compresión
- **Uso**: Se ejecuta automáticamente por la tarea programada los sábados

## Requisitos de los Scripts

1. **backup_simple.bat**
   - SQL Server instalado y accesible
   - Base de datos VentasBD2 existente
   - Permisos de escritura en la carpeta de backups

2. **programar_tareas.bat**
   - Permisos de administrador en Windows
   - Los scripts deben estar en la carpeta correcta
   - No requiere interacción del usuario

3. **limpiar_antiguos.bat**
   - 7-Zip instalado en `C:\Program Files\7-Zip\7z.exe`
   - Permisos de escritura en la carpeta de backups
   - Los archivos .bak deben estar en la carpeta correcta

## Ejecución Manual

Si se necesita ejecutar los scripts manualmente:

1. **backup_simple.bat**
```bash
cd "C:\BackupsVentasBD2\scripts"
backup_simple.bat
```

2. **programar_tareas.bat** (como administrador)
```bash
cd "C:\BackupsVentasBD2\scripts"
programar_tareas.bat
```

3. **limpiar_antiguos.bat**
```bash
cd "C:\BackupsVentasBD2\scripts"
limpiar_antiguos.bat
```

## Notas Importantes

- Los scripts son independientes del formato regional de fecha y hora
- El sistema usa WMIC para obtener la fecha y hora actual
- Los backups se almacenan en `C:\BackupsVentasBD2\`
- Se recomienda mantener un respaldo físico adicional de los backups importantes
- Los backups antiguos se comprimen para optimizar espacio
