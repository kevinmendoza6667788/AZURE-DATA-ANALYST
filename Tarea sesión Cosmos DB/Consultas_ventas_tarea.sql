-- Listar todas las ventas realizadas por “María López”.
SELECT * FROM c WHERE c.asesor = "María López"


-- Mostrar idVenta, asesor y cantidad de las ventas en zona “Norte”.
SELECT c.idVenta, c.asesor, c.cantidad FROM c WHERE c.zona = "Norte"


-- Contar cuántas ventas se hicieron cada día (fecha).
SELECT c.fecha, COUNT(1) AS cantidadVentas FROM c GROUP BY c.fecha


-- Obtener la cantidad total vendida por cada asesor.
SELECT c.asesor, SUM(c.cantidad) AS totalVendido FROM c GROUP BY c.asesor


-- Listar las ventas donde cantidad sea mayor o igual a 3.
SELECT * FROM c WHERE c.cantidad >= 3


-- Mostrar las primeras 5 ventas ordenadas por fecha ascendente.
SELECT TOP 5 * FROM c ORDER BY c.fecha ASC


-- Filtrar ventas entre “2025-06-05” y “2025-06-10”.
SELECT * FROM c WHERE c.fecha BETWEEN "2025-06-05" AND "2025-06-10"


-- Encontrar el asesor con más ventas (número de registros) en total.
-- Nota: En Cosmos DB SQL nativo, el ORDER BY con funciones de agregación (como COUNT) puede requerir configuración adicional o realizar el ordenamiento en el cliente.
SELECT c.asesor, COUNT(1) AS numeroVentas FROM c GROUP BY c.asesor


-- Calcular la cantidad promedio vendida por zona.
SELECT c.zona, AVG(c.cantidad) AS promedioVendido FROM c GROUP BY c.zona


-- Buscar ventas cuyo idVenta comience con “V20”.
SELECT * FROM c WHERE STARTSWITH(c.idVenta, "V20")