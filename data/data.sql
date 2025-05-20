USE VentasBD2;
GO

-- Insertar categorías
INSERT INTO Categorias (Nombre, Descripcion)
VALUES 
('Electrónicos', 'Dispositivos electrónicos y accesorios'),
('Hogar', 'Artículos para el hogar'),
('Oficina', 'Productos de oficina y papelería'),
('Tecnología', 'Tecnología y computación'),
('Otros', 'Otras categorías diversas');
GO

-- Insertar empresa proveedora
INSERT INTO Contactos (Direccion, Telefono, Email)
VALUES ('Av. Ejemplo 123', '987654321', 'proveedor@ejemplo.com');

DECLARE @contactoId INT = SCOPE_IDENTITY();

INSERT INTO Empresas (Ruc, RazonSocial, ContactoID)
VALUES ('20123456789', 'TecnoProveedores S.A.C.', @contactoId);

-- Insertar proveedor
INSERT INTO Proveedores (Ruc, Activo, Calificacion)
VALUES ('20123456789', 1, 5);

-- Insertar productos
INSERT INTO Productos (CodigoCategoria, Ruc, Nombre, Descripcion, PrecioCompra, PrecioVenta, Stock, Estado)
VALUES 
(1, '20123456789', 'Laptop HP 15-dw1004la', 'Laptop HP 15.6", Intel Core i5, 8GB RAM, 256GB SSD', 1899.00, 2499.00, 15, 'disponible'),
(1, '20123456789', 'Smartphone Samsung Galaxy A54', 'Smartphone 128GB, 6GB RAM, Cámara 50MP', 999.00, 1499.00, 30, 'disponible'),
(2, '20123456789', 'Cafetera Oster', 'Cafetera automática de 12 tazas, color negro', 89.90, 149.90, 20, 'disponible'),
(3, '20123456789', 'Silla de oficina ergonómica', 'Silla ajustable con soporte lumbar', 199.00, 299.00, 12, 'disponible'),
(4, '20123456789', 'Disco Duro Externo 1TB', 'Disco duro portátil USB 3.0, color plateado', 149.00, 219.00, 25, 'disponible');
GO