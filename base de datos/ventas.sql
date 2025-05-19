
-- Esquema de Recursos Humanos --
-- Tabla de datos de contacto
CREATE TABLE Contactos (
    ContactoID INT PRIMARY KEY IDENTITY(1,1),
    Direccion TEXT,
    Telefono CHAR(9),
    Email TEXT
);

-- Personas
CREATE TABLE Personas (
    Dni CHAR(8) PRIMARY KEY,
    Nombre TEXT NOT NULL,
    ApellidoPaterno TEXT NOT NULL,
    ApellidoMaterno TEXT NOT NULL,
    ContactoID INT,
    CONSTRAINT FK_Personas_Contacto FOREIGN KEY (ContactoID) REFERENCES Contactos(ContactoID) ON UPDATE CASCADE
);

-- Empleados
CREATE TABLE Empleados (
    CodigoEmpleado INT PRIMARY KEY IDENTITY(1,1),
    Dni CHAR(8) NOT NULL,
    CONSTRAINT FK_Empleados_Personas FOREIGN KEY (Dni) REFERENCES Personas(Dni) ON UPDATE CASCADE
);

-- Clientes naturales
CREATE TABLE Clientes (
    Dni CHAR(8) PRIMARY KEY,
    TipoCliente TEXT NOT NULL DEFAULT 'regular',
    CONSTRAINT FK_Clientes_Personas FOREIGN KEY (Dni) REFERENCES Personas(Dni) ON UPDATE CASCADE
);

-- Clientes que son empresa
CREATE TABLE ClientesEmpresa (
    RUC CHAR(11) PRIMARY KEY,
    RazonSocial TEXT NOT NULL,
    ContactoID INT,
    CONSTRAINT FK_ClientesEmpresa_Contacto FOREIGN KEY (ContactoID) REFERENCES Contactos(ContactoID) ON UPDATE CASCADE
);

-- Esquema de Inventarios --
