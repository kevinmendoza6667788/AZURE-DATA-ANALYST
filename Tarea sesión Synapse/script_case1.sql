-- CREATE DATABASE db_pedan6;

use db_pedan6;

CREATE EXTERNAL DATA SOURCE Reporte
WITH(
    LOCATION = 'abfss://dlspedan0002@dlsexternalpedan0001.dfs.core.windows.net/'
)


CREATE EXTERNAL FILE FORMAT ParquetFileFormat
WITH(
    FORMAT_TYPE = PARQUET
)


CREATE EXTERNAL TABLE [dbo].[Reporte_VentasTotalesPorProducto]
WITH(
    LOCATION = 'golden/ventas_totales_producto/', -- 'golden/ventas_totales_producto/'
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
    CAST(SUM(V.cantidad_vendida) AS INT) AS total_cantidad_vendida
FROM Ventas V
INNER JOIN Productos P
    ON V.id_producto = P.id_producto
GROUP BY
    P.nombre_producto,
    P.categoria;
GO


