-- Listar todos los productos cuyo precio sea mayor a 40.
SELECT * FROM c WHERE c.price > 40


-- Mostrar id, name y SKU de los productos que pertenecen a la categoría 200000002.
SELECT c.id, c.name, c.SKU FROM c WHERE c.categoryID = "200000002"


-- Contar cuántos productos hay en cada categoryID.
SELECT c.categoryID, COUNT(1) AS cantidadProductos FROM c GROUP BY c.categoryID


-- Obtener el producto más caro de cada categoría.
SELECT c.categoryID, MAX(c.price) AS precioMaximo FROM c GROUP BY c.categoryID


-- Listar productos cuyo name contenga tanto “Helmet” como “Road”.
SELECT * FROM c WHERE CONTAINS(c.name, "Helmet") AND CONTAINS(c.name, "Road")


-- Mostrar los 5 productos con menor precio, ordenados de forma ascendente.
SELECT TOP 5 * FROM c ORDER BY c.price ASC


-- Encontrar productos cuyo SKU termine en “-05”.
SELECT * FROM c WHERE ENDSWITH(c.SKU, "-05")


-- Calcular el precio promedio de los productos de la categoría 200000003.
SELECT AVG(c.price) AS precioPromedio FROM c WHERE c.categoryID = "200000003"


-- Filtrar productos con precio entre 20 y 60 y ordenar por name de forma descendente.
SELECT * FROM c WHERE c.price BETWEEN 20 AND 60 ORDER BY c.name DESC


-- Buscar productos donde la descripción (description) contenga el número de modelo (por ejemplo, “30” para “Cycling Jersey,30”).
SELECT * FROM c WHERE CONTAINS(c.description, "30")
