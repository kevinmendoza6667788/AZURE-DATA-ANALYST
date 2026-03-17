use db_pedan6;

CREATE EXTERNAL TABLE [dbo].[Reporte_ClientesMayorCompras]
WITH(
    LOCATION = 'golden/clientes_mayor_compras/', 
    DATA_SOURCE = Reporte, 
    FILE_FORMAT = ParquetFileFormat
)
AS
WITH Ventas AS (
    SELECT
        id_venta,
        id_cliente
    FROM
        OPENROWSET(
            BULK 'https://dlsexternalpedan0001.dfs.core.windows.net/dlspedan0002/bronze/ventas.csv', 
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIELDTERMINATOR = ',',
            HEADER_ROW = TRUE
        )
        WITH(
            id_venta INT,
            id_cliente INT
        ) AS data
),
Clientes AS (
    SELECT
        id_cliente,
        nombre
    FROM
        OPENROWSET(
            BULK 'https://dlsexternalpedan0001.dfs.core.windows.net/dlspedan0002/bronze/clientes.csv',
            FORMAT = 'CSV',
            PARSER_VERSION = '2.0',
            FIELDTERMINATOR = ',',
            HEADER_ROW = TRUE
        )
        WITH(
            id_cliente INT,
            nombre VARCHAR(150) COLLATE Latin1_General_100_CI_AS_SC_UTF8
        ) AS data
)
SELECT
    C.nombre AS nombre_cliente,
    CAST(COUNT(V.id_venta) AS INT) AS cantidad_compras
FROM Ventas V
INNER JOIN Clientes C
    ON V.id_cliente = C.id_cliente
GROUP BY
    C.nombre;
GO



