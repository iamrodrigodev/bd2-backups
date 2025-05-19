USE VentasBD2;
GO

CREATE PARTITION FUNCTION fnParticionAuditoriaVentas(datetime)
AS RANGE RIGHT FOR VALUES (
    '2025-05-01',
    '2026-01-01',
    '2027-01-01',
    '2028-01-01'
);
GO

CREATE PARTITION SCHEME schParticionAuditoriaVentas
AS PARTITION fnParticionAuditoriaVentas
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);
GO

CREATE TABLE AuditoriaVentas (
    IdAuditoria INT NOT NULL IDENTITY(1,1),
    CodigoVenta INT NOT NULL,
    FechaRegistro DATETIME NOT NULL,
    Accion VARCHAR(50) NOT NULL, -- INSERT, UPDATE, DELETE, CANCELAR
    Usuario NVARCHAR(128) NOT NULL,
    FechaHora DATETIME NOT NULL DEFAULT GETDATE(),
    DniAnterior CHAR(8),
    DniNuevo CHAR(8),
    RucAnterior CHAR(11),
    RucNuevo CHAR(11),
    CodigoEmpleadoAnterior INT,
    CodigoEmpleadoNuevo INT,
    CantidadProductos INT,
    MontoTotal DECIMAL(18,2),
    Descripcion NVARCHAR(1000),
    CONSTRAINT PK_AuditoriaVentas PRIMARY KEY (IdAuditoria, FechaHora),
    CONSTRAINT FK_AuditoriaVentas_Ventas FOREIGN KEY (CodigoVenta, FechaRegistro) REFERENCES Ventas(CodigoVenta, FechaRegistro)
) ON schParticionAuditoriaVentas(FechaHora);
GO


CREATE NONCLUSTERED INDEX IX_AuditoriaVentas_CodigoVenta ON AuditoriaVentas(CodigoVenta);
GO
CREATE NONCLUSTERED INDEX IX_AuditoriaVentas_FechaHora ON AuditoriaVentas(FechaHora);
GO
CREATE NONCLUSTERED INDEX IX_AuditoriaVentas_Usuario ON AuditoriaVentas(Usuario);
GO


CREATE TRIGGER tr_Auditoria_Ventas_Insert
ON Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @MontoTotal DECIMAL(18,2);
    
    -- Calcular monto total
    SELECT 
        @MontoTotal = SUM(dv.Cantidad * p.PrecioVenta)
    FROM inserted i
    INNER JOIN DetalleVentas dv ON i.CodigoVenta = dv.CodigoVenta
    INNER JOIN Productos p ON dv.CodigoProducto = p.CodigoProducto
    GROUP BY i.CodigoVenta;

    INSERT INTO AuditoriaVentas (
        CodigoVenta,
        FechaRegistro,
        Accion,
        Usuario,
        DniNuevo,
        RucNuevo,
        CodigoEmpleadoNuevo,
        CantidadProductos,
        MontoTotal,
        Descripcion
    )
    SELECT 
        i.CodigoVenta,
        i.FechaRegistro,
        'INSERT',
        SYSTEM_USER,
        i.Dni,
        i.Ruc,
        i.CodigoEmpleado,
        (SELECT COUNT(*) FROM DetalleVentas WHERE CodigoVenta = i.CodigoVenta),
        @MontoTotal,
        'Venta registrada'
    FROM inserted i;
END;
GO

CREATE TRIGGER tr_Auditoria_Ventas_Update
ON Ventas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Dni) OR UPDATE(Ruc) OR UPDATE(CodigoEmpleado) OR UPDATE(FechaRegistro)
    BEGIN
        INSERT INTO AuditoriaVentas (
            CodigoVenta,
            FechaRegistro,
            Accion,
            Usuario,
            DniAnterior,
            DniNuevo,
            RucAnterior,
            RucNuevo,
            CodigoEmpleadoAnterior,
            CodigoEmpleadoNuevo,
            Descripcion
        )
        SELECT 
            i.CodigoVenta,
            i.FechaRegistro,
            'UPDATE',
            SYSTEM_USER,
            d.Dni,
            i.Dni,
            d.Ruc,
            i.Ruc,
            d.CodigoEmpleado,
            i.CodigoEmpleado,
            'Venta actualizada'
        FROM inserted i
        INNER JOIN deleted d ON i.CodigoVenta = d.CodigoVenta;
    END
END;
GO

CREATE TRIGGER tr_Auditoria_Ventas_Delete
ON Ventas
INSTEAD OF DELETE
AS
BEGIN
    -- Registrar la auditoría
    INSERT INTO AuditoriaVentas (
        CodigoVenta,
        FechaRegistro,
        Accion,
        Usuario,
        DniAnterior,
        RucAnterior,
        CodigoEmpleadoAnterior,
        Descripcion
    )
    SELECT 
        d.CodigoVenta,
        d.FechaRegistro,
        'DELETE',
        SYSTEM_USER,
        d.Dni,
        d.Ruc,
        d.CodigoEmpleado,
        'Venta anulada'
    FROM deleted d;

    -- Restablecer stocks y verificar estados (deberia estar en otro trigger llamado tr_RestablecerStocks)
    UPDATE p
    SET 
        Stock = p.Stock + dv.Cantidad,
        Estado = CASE 
            WHEN p.Stock + dv.Cantidad > 0 THEN 'disponible'
            ELSE 'agotado'
        END
    FROM Productos p
    INNER JOIN DetalleVentas dv ON p.CodigoProducto = dv.CodigoProducto
    INNER JOIN deleted d ON dv.CodigoVenta = d.CodigoVenta;
END;
GO