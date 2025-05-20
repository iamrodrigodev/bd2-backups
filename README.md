# 📊 Sistema de Gestión de Ventas - Base de Datos -Seguridad en Ventas

<div style="width: 100%; text-align: center; overflow: auto; margin-bottom: 30px;">
  <img 
    src="base de datos/ventas.png" 
    alt="Diagrama de la Base de Datos de Ventas"
    style="max-width: 100%; height: auto; display: block; margin: 0 auto; border: 1px solid #e1e4e8; border-radius: 6px;"
  >
</div>

## 🗃️ Estructura de la Base de Datos

### 🔄 Particionamiento de Tablas

#### 1. Tabla de Ventas
```sql
-- Crear la función de partición
CREATE PARTITION FUNCTION fnParticionVentasPorAno(datetime)
AS RANGE RIGHT FOR VALUES (
    '2025-05-01',
    '2026-01-01',
    '2027-01-01',
    '2028-01-01'
);

-- Crear el esquema de partición
CREATE PARTITION SCHEME schParticionVentasPorAno
AS PARTITION fnParticionVentasPorAno
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);

-- Crear la tabla particionada
CREATE TABLE Ventas (
    CodigoVenta INT NOT NULL IDENTITY(1,1),
    Dni CHAR(8) NULL,
    Ruc CHAR(11) NULL,
    CodigoEmpleado INT NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    -- Resto de columnas...
    CONSTRAINT PK_Ventas PRIMARY KEY (CodigoVenta, FechaRegistro)
) ON schParticionVentasPorAno(FechaRegistro);
```

#### 2. Tabla de Auditoría
```sql
-- Crear la función de partición
CREATE PARTITION FUNCTION fnParticionAuditoriaVentas(datetime)
AS RANGE RIGHT FOR VALUES (
    '2025-05-01',
    '2026-01-01',
    '2027-01-01',
    '2028-01-01'
);

-- Crear el esquema de partición
CREATE PARTITION SCHEME schParticionAuditoriaVentas
AS PARTITION fnParticionAuditoriaVentas
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);

-- Crear la tabla de auditoría particionada
CREATE TABLE AuditoriaVentas (
    IdAuditoria INT NOT NULL IDENTITY(1,1),
    CodigoVenta INT NOT NULL,
    FechaRegistro DATETIME NOT NULL,
    Accion VARCHAR(50) NOT NULL,
    Usuario NVARCHAR(128) NOT NULL,
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    -- Resto de columnas...
    CONSTRAINT PK_AuditoriaVentas PRIMARY KEY (IdAuditoria, FechaHora)
) ON schParticionAuditoriaVentas(FechaHora);
```

#### Beneficios del Particionamiento
- **Mejor rendimiento**: Consultas más rápidas al acceder solo a particiones relevantes
- **Mantenimiento simplificado**: Posibilidad de hacer mantenimiento por rangos de fechas
- **Mejor gestión de almacenamiento**: Distribución óptima de datos en los archivos de la base de datos
- **Eliminación eficiente**: Se pueden eliminar particiones enteras de datos antiguos de manera eficiente

### 🏗️ Tablas Principales

### Tablas Principales
- **Contactos**: Almacena información de contacto compartida
- **Personas**: Datos personales de clientes individuales
- **Empresas**: Información de clientes corporativos
- **Productos**: Catálogo de productos disponibles
- **Ventas**: Registro de transacciones de venta
- **DetalleVentas**: Detalle de productos en cada venta

### Características Técnicas
- **Particionamiento**: Por fechas para optimizar consultas históricas
- **Índices**: Optimizados para búsquedas frecuentes
- **Claves foráneas**: Para mantener la integridad referencial
- **Triggers**: Para automatización de tareas

## 🔍 Auditorías

### Archivos de Auditoría
- `auditorias/auditorias_ventas.sql`

### Tablas de Auditoría
- **AuditoriaVentas**: Registra todas las acciones realizadas sobre las ventas
  - Inserción de nuevas ventas
  - Actualizaciones de ventas existentes
  - Cancelaciones de ventas
  - Eliminaciones

### Características de Auditoría
- Particionamiento por fechas
- Índices optimizados
- Registro de usuario que realizó la acción
- Historial de cambios en datos sensibles


## 📋 Estructura del Proyecto
```
├── auditorias/
│   └── auditorias_ventas.sql
├── base de datos/
│   ├── ventas.sql
│   └── ventas.png
├── data/
│   └── data.sql
└── scripts/
    ├── backup_ventas.bat
    ├── comprimir_backups.bat
    └── limpiar_backups.bat
```
