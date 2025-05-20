# 📜 Scripts de Mantenimiento Automatizado

Bienvenido a la documentación de los scripts de mantenimiento para la base de datos de Ventas. Estos scripts están diseñados para automatizar tareas críticas de mantenimiento.

## 📋 Lista de Scripts

### 🔄 1. `backup_ventas.bat`
**Propósito**: Realizar respaldos completos de la base de datos VentasBD2.

📂 **Ubicación**: `scripts/backup_ventas.bat`

✅ **Características Principales**:
- Respaldo completo con marca de tiempo
- Verificación de espacio en disco
- Generación de logs detallados
- Notificaciones de estado

📝 **Uso**:
```bash
backup_ventas.bat
```

📸 **Guía Visual**:
Todas las capturas de pantalla para configurar la tarea programada en Windows:
- [Pasos para configurar el backup programado](https://github.com/RodrigoStranger/bd2-backups/tree/main/imagenes/script%20lunes%20miercoles%20sabado%20medianoche)

---

### 🗜️ 2. `comprimir_backups.bat`
**Propósito**: Comprimir archivos de backup antiguos para ahorrar espacio.

📂 **Ubicación**: `scripts/comprimir_backups.bat`

✅ **Características Principales**:
- Filtrado por antigüedad (3+ días)
- Mantenimiento de archivos originales
- Reporte de ahorro de espacio

⚙️ **Configuración**:
Editar las variables al inicio del archivo:
```batch
set "BACKUP_PATH=C:\BackupsVentasBD2"
set "DIAS_ANTIGUEDAD=3"
```

📝 **Uso**:
```bash
comprimir_backups.bat
```

📸 **Guía Visual**:
Todas las capturas de configuración en el Programador de Tareas:
- [Pasos para configurar la compresión diaria](https://github.com/RodrigoStranger/bd2-backups/tree/main/imagenes/script%20conversion%20a%20zip%20despues%20de%203%20dias)

---

### 🗑️ 3. `limpiar_backups.bat`
**Propósito**: Eliminar backups antiguos según criterios de antigüedad.

📂 **Ubicación**: `scripts/limpiar_backups.bat`

✅ **Características Principales**:
- Eliminación selectiva (15+ días)
- Reporte detallado
- Verificación de seguridad
- Modo simulacro disponible

📝 **Uso**:
```bash
limpiar_backups.bat [opciones]
```

📸 **Guía Visual**:
Todas las capturas para configurar la limpieza semanal:
- [Pasos para configurar la limpieza semanal](https://github.com/RodrigoStranger/bd2-backups/tree/main/imagenes/script%20eliminacion%20de%20archivos%20despued%20de%2015%20dias)

🔧 **Opciones**:
  /dry-run     Mostrar qué archivos se eliminarían sin eliminarlos
  /force       Forzar eliminación sin confirmación

## 📅 Programación de Tareas

| Tarea | Frecuencia | Hora |
|-------|------------|------|
| 🔄 Backup | Lunes, Miércoles, Sábado | 00:00:00 |
| 🗜️ Compresión | Diario | 00:00:00 |
| 🗑️ Limpieza | Semanal (Sábados) | 00:00:00 |

### Configuración recomendada en el Programador de Tareas de Windows:

1. **Tarea de Backup**
   - Activar: `Ejecutar con los privilegios más altos`
   - Configuración para Windows 10/11
   - Repetir cada: `1 semana` en los días seleccionados

2. **Tarea de Compresión**
   - Activar: `Ejecutar sin importar si el usuario ha iniciado sesión o no`
   - No detener la tarea si se ejecuta más de: `1 hora`
   - Repetir cada: `1 día`

3. **Tarea de Limpieza**
   - Comenzar en: `Ruta completa a limpiar_backups.bat`
   - Agregar argumento: `/force` para ejecución desatendida
   - Repetir cada: `1 semana` los sábados

## 📝 Notas Importantes

1. Verificar que el servicio de SQL Server esté en ejecución
2. Asegurar permisos de escritura en las rutas de destino
3. Revisar regularmente los logs en `C:\BackupsVentasBD2\Logs\`

## 🔒 Seguridad

- Los scripts verifican permisos antes de ejecutar operaciones críticas
- Se recomienda ejecutar con una cuenta con privilegios adecuados
- Los logs contienen información sensible, proteger el acceso a los mismos
