--* Realizar consultas para contestar las siguientes preguntas:

SELECT * FROM menu_items;

--*Encontrar el número de artículos en el menú.--*Resultado:32--

SELECT COUNT(*) AS total_items
FROM menu_items;

--*¿Cuál es el artículo menos caro y el más caro en el menú?
--*Más caro: Shrimp Scampi $19.95 USD*
SELECT item_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1; 

--*Menos caro: Edamame $5.00 USD*
SELECT item_name, price
FROM menu_items
ORDER BY price ASC
LIMIT 1

--*¿Cuántos platos americanos hay en el menú? *Respuesta: 6 Platillos**

SELECT COUNT(*) AS American_Category
FROM menu_items
WHERE category= 'American';

--*¿Cuál es el precio promedio de los platos? *Respuesta: $13.29 USD Promedio**

SELECT ROUND(AVG(price),2) AS Precio_promedio
FROM menu_items;

--*Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
SELECT * FROM order_details;

--*Realizar consultas para contestar las siguientes preguntas:

--*¿Cuántos pedidos únicos se realizaron en total? Respuesta: 5,370*
SELECT COUNT(DISTINCT order_id) AS Pedidos_Unicos
FROM order_details;

--*¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?**Respuesta:5 lineas con recuento
--14 artículos.

SELECT order_id,
COUNT (item_id) AS Total_items
FROM order_details
GROUP BY order_id
ORDER BY total_items DESC
LIMIT 5;


--*¿Cuándo se realizó el primer pedido y el último pedido?

--Primer pedido: 2023-01-01 Hora 11:38:36

SELECT 
MIN (CONCAT (order_date,'&',order_time)) AS Primer_Pedido
FROM order_details;

--Último pedido: 2023-03-31 Hora 22:15:48
SELECT 
MAX (CONCAT (order_date,'&',order_time)) AS Primer_Pedido
FROM order_details;

--*¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'? Respuesta: 308

SELECT COUNT(DISTINCT order_id) AS total_pedidofecha
FROM order_details
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';

--*Usar ambas tablas para conocer la reacción de los clientes respecto al menú.

--*Realizar un left join entre entre order_details y menu_items con el identificador
--*item_id(tabla order_details) y menu_item_id(tabla menu_items).

SELECT 
    od.order_id,
    od.order_date,
    od.order_time,
    od.item_id,
    mi.item_name,
    mi.category,
    mi.price
FROM order_details od
LEFT JOIN menu_items mi
    ON od.item_id = mi.menu_item_id;
	

--*Objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
--*restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y
--*utiliza los resultados obtenidos para llegar a estas conclusiones.

--Top 5 de productos vendidos: Hamburger/Edamama/Korean Beef/Cheeseburger/French Fries
SELECT 
    mi.item_name,
    COUNT(*) AS No_veces_ordenadas
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY times_ordered DESC
LIMIT 5;

--Top tres en categoria populares de ventas: Asian, Italian & Mexican.

SELECT 
mi.category,
	COUNT(*) AS Veces_category
FROM order_details od
LEFT JOIN menu_items mi ON od.item_id= mi.menu_item_id
GROUP BY mi.category
ORDER BY Veces_category DESC
LIMIT 3;

--Top tres productos con más ganancias: Korean Beef, Spaghetti y Tofu.

SELECT 
    mi.item_name,
    COUNT(*) AS quantity_sold,
    mi.price,
    ROUND(COUNT(*) * mi.price, 2) AS total_revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name, mi.price
ORDER BY total_revenue DESC
LIMIT 3;

--Producto menos vendido: Chicken Tacos.
SELECT 
    mi.item_name,
    COUNT(od.item_id) AS quantity_sold
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY quantity_sold ASC
LIMIT 1;

--Top 3 fechas con mayores ventas: Tendencia irregular pero posibles promociones en fechas.
SELECT 
    od.order_date,
    ROUND(SUM(mi.price), 2) AS total_revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_date
ORDER BY total_revenue DESC
LIMIT 5;


