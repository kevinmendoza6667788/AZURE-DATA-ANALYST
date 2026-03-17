use db_pedan6;

CREATE EXTERNAL TABLE [dbo].[Reporte_ProductosBajaVenta]
WITH(
    LOCATION = 'golden/productos_baja_venta/', 
    DATA_SOURCE = Reporte, 
    FILE_FORMAT = ParquetFileFormat
)
AS
WITH Ventas AS (
    SELECT
        id_producto,
        cantidad_vendida
    FROM
        OPENROWSET(
            BULK 'https://dlsexternalpedan0001.dfs.core.windows.net/dlspedan0002/bronze/ventas.csv',
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIELDTERMINATOR = ',',
            HEADER_ROW = TRUE
        )
        WITH(
            id_producto INT,
            cantidad_vendida INT
        ) AS data
),
Productos AS (
    SELECT
        id_producto,
        nombre_producto,
        categoria
    FROM
        OPENROWSET(
            BULK 'https://dlsexternalpedan0001.dfs.core.windows.net/dlspedan0002/bronze/productos.csv', 
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIELDTERMINATOR = ',',
            HEADER_ROW = TRUE
        )
        WITH(
            id_producto INT,
            nombre_producto VARCHAR(150) COLLATE Latin1_General_100_CI_AS_SC_UTF8,
            categoria VARCHAR(100) COLLATE Latin1_General_100_CI_AS_SC_UTF8
        ) AS data
)
SELECT
    P.nombre_producto,
    P.categoria,
    CAST(SUM(V.cantidad_vendida) AS INT) AS cantidad_ventas
FROM Ventas V
INNER JOIN Productos P
    ON V.id_producto = P.id_producto
GROUP BY
    P.nombre_producto,
    P.categoria
HAVING
    CAST(SUM(V.cantidad_vendida) AS INT) < 15;
GO


