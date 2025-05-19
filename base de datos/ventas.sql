CREATE DATABASE VentasBD2;

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Esquema de Recursos Humanos --

-- Tabla de datos de contacto
CREATE TABLE Contactos (
    ContactoID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Direccion TEXT,
    Telefono CHAR(9),
    Email TEXT,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);

-- Personas
CREATE TABLE Personas (
    Dni CHAR(8) NOT NULL PRIMARY KEY,
    Nombre TEXT NOT NULL,
    ApellidoPaterno TEXT NOT NULL,
    ApellidoMaterno TEXT NOT NULL,
    ContactoID INT,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Personas_Contacto FOREIGN KEY (ContactoID) REFERENCES Contactos(ContactoID) ON UPDATE CASCADE
);

-- Empresas
CREATE TABLE Empresas (
    Ruc CHAR(11) NOT NULL PRIMARY KEY,
    RazonSocial TEXT NOT NULL,
    ContactoID INT,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Empresas_Contacto FOREIGN KEY (ContactoID) REFERENCES Contactos(ContactoID) ON UPDATE CASCADE
);

-- Empleados
CREATE TABLE Empleados (
    CodigoEmpleado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    Dni CHAR(8) NOT NULL,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Empleados_Personas FOREIGN KEY (Dni) REFERENCES Personas(Dni) ON UPDATE CASCADE
);

-- Clientes naturales
CREATE TABLE Clientes (
    Dni CHAR(8) NOT NULL PRIMARY KEY,
    TipoCliente TEXT DEFAULT 'regular',
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Clientes_Personas FOREIGN KEY (Dni) REFERENCES Personas(Dni) ON UPDATE CASCADE
);

-- Clientes que son empresa
CREATE TABLE ClientesEmpresa (
    Ruc CHAR(11) NOT NULL PRIMARY KEY,
    Rubro TEXT DEFAULT 'general',
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ClientesEmpresa_Empresas FOREIGN KEY (Ruc) REFERENCES Empresas(Ruc) ON UPDATE CASCADE
);

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Esquema de Inventarios --

-- Categorias
CREATE TABLE Categorias (
    CodigoCategoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) UNIQUE NOT NULL,
    Descripcion TEXT,
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE()
);

-- Proveedores
CREATE TABLE Proveedores (
    Ruc CHAR(11) NOT NULL PRIMARY KEY,
    Activo BIT DEFAULT 1,
    Calificacion INT CHECK (Calificacion BETWEEN 1 AND 5),
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Proveedores_Empresas FOREIGN KEY (Ruc) REFERENCES Empresas(Ruc) ON UPDATE CASCADE
);

-- Productos
CREATE TABLE Productos (
    CodigoProducto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    CodigoCategoria INT,
    Ruc CHAR(11),
    Nombre NVARCHAR(100) UNIQUE NOT NULL,
    Descripcion TEXT,
    PrecioCompra FLOAT NOT NULL,
    PrecioVenta FLOAT NOT NULL,
    Stock INT NOT NULL,
    Estado VARCHAR(10) CHECK (Estado IN ('disponible', 'agotado')) NOT NULL DEFAULT 'disponible',
    FechaRegistro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Productos_Categoria FOREIGN KEY (CodigoCategoria) REFERENCES Categorias(CodigoCategoria) ON UPDATE CASCADE,
    CONSTRAINT FK_Productos_Proveedor FOREIGN KEY (Ruc) REFERENCES Proveedores(Ruc) ON UPDATE CASCADE
);

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Esquema de Ventas --

-- Ventas
CREATE TABLE Ventas (
    CodigoVenta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Dni CHAR(8) NULL,
    Ruc CHAR(11) NULL,
    CodigoEmpleado INT NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CHK_SoloUnCliente CHECK ((Dni IS NOT NULL AND Ruc IS NULL) OR (Dni IS NULL AND Ruc IS NOT NULL)),
    CONSTRAINT FK_Ventas_ClientesPersona FOREIGN KEY (Dni) REFERENCES Clientes(Dni) ON UPDATE CASCADE,
    CONSTRAINT FK_Ventas_ClientesEmpresa FOREIGN KEY (Ruc) REFERENCES ClientesEmpresa(Ruc),
    CONSTRAINT FK_Ventas_Empleados FOREIGN KEY (CodigoEmpleado) REFERENCES Empleados(CodigoEmpleado)
);

-- Detalle de ventas
CREATE TABLE DetalleVentas (
    CodigoVenta INT NOT NULL,
    CodigoProducto INT NOT NULL,
    Cantidad INT NOT NULL,
    PRIMARY KEY (CodigoVenta, CodigoProducto),
    CONSTRAINT FK_DetalleVentas_Ventas FOREIGN KEY (CodigoVenta) REFERENCES Ventas(CodigoVenta) ON UPDATE CASCADE,
    CONSTRAINT FK_DetalleVentas_Productos FOREIGN KEY (CodigoProducto) REFERENCES Productos(CodigoProducto)
);