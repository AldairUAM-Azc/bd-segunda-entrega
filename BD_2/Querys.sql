-- *********************************************************************
-- Querys
-- *********************************************************************
use cientubi;
-- Consultas Hernández Aguilar Jonathan Abraham 2182004371
/*
1.- Muestra el nombre de la pelicula, duracion y clasificacion de las peliculas cuyo titulo empiecen con "The" y la duración esté entre 90 y 120 minutos. 
*/
SELECT p.titulo, p.duracion, p.clasificacion
FROM pelicula p WHERE p.titulo LIKE 'The%' AND p.duracion BETWEEN 90 AND 120;

/*
2.- Se quiere conocer la duración promedio de las películas distribuidas por cada distribuidor, pero solo para aquellos distribuidores cuya duración promedio sea mayor a 100 minutos. 
La consulta debe mostrar el nombre del distribuidor y su duración promedio de las películas.
*/
SELECT d.nombre AS distribuidor, AVG(p.duracion) AS duracion_promedio
FROM distribuidor d JOIN  pelicula p ON d.id = p.distribuidor
GROUP BY d.nombre
HAVING AVG(p.duracion) > 100;

/*
3.- ¿Cual es la funcion mas tarde que hay, en que idioma esta, y cual es su director y distribuidor?  

Este se me hizo interesante por que la funcion mas tarde curiosamente no tiene director, entonces, no se puede hacer un INNER JOIN para la union. 
*/
SELECT f.horario, f.idioma, dir.nombre AS director,  d.nombre AS distribuidor
FROM funcion f
INNER JOIN pelicula p ON f.id_pelicula = p.id
LEFT JOIN  director dir ON p.director = dir.id
INNER JOIN distribuidor d ON p.distribuidor = d.id
WHERE f.horario = (SELECT MAX(horario) FROM funcion);

/*
4.- Se necesita saber cuantas funciones hay y en que idioma estan dichas funciones. 
*/
SELECT idioma, COUNT(*) AS cantidad_funciones
FROM funcion
GROUP BY idioma;

/*
5.- Contar cuántos distribuidores hay de peliclas con  clasificación por diferentes de "R".
*/
SELECT COUNT(DISTINCT d.id) AS total_distribuidores
FROM distribuidor d
INNER JOIN pelicula p ON d.id = p.distribuidor
WHERE p.clasificacion != 'R';




/* 
6.- En una revisión, necesitan saber cuales fueron las ultimas 15 funciones programadas. Neceitan ver el nombre de la pelicula y los datos de la funcion tales como fecha, hora y sala.
*/
SELECT p.titulo, f.fecha, f.horario, f.id_sala AS sala FROM funcion f
INNER JOIN pelicula p ON p.id = f.id_pelicula
 ORDER BY f.id DESC LIMIT 15;

/*
7.- Se quiere  una vista general de las peliculas del cine, para ello se requiere ver una tabla con el nombre de la pelicula, nombre del director (una sola celda), nombre de la distribuidora,
ademas de saber la clasificacion de las peliculas. 
*/
SELECT p.titulo, concat(dir.nombre, " ", dir.apellido) AS director, d.nombre AS distribuidora, p.clasificacion
FROM pelicula p
INNER JOIN distribuidor d ON p.distribuidor = d.id
INNER JOIN director dir ON p.director = dir.id;

/*
8.- Muestra todos los registros de la tabla pelicula, incluyendo aquellas que no tienen asignado un distribuidor y/o director. 
 Se debe mostrar el título de la película, el nombre del distribuidor (si está disponible) y el nombre del director (si está disponible). 
 */
SELECT p.titulo, d.nombre AS Distribuidor, dir.nombre AS Director
FROM pelicula p
LEFT JOIN distribuidor d ON p.distribuidor = d.id
LEFT JOIN director dir ON p.director = dir.id;

/*
9.- Se requiere saber el nombre del distribuidor y las películas que han distribuido. 
Es importante incluir también aquellos distribuidores que no tienen películas asociadas. 
La consulta debe mostrar el nombre del distribuidor, el título de la película (si existe) y la duración de la película (si existe).
*/

SELECT p.titulo, p.duracion, d.nombre AS Distribuidor
FROM pelicula p 
RIGHT JOIN distribuidor d ON d.id = p.distribuidor;

/*
10.- Calcular la cantidad total de funciones programadas para películas que tengan clasificaciones específicas, como "PG", "PG-13" y "R" considerando solo las salas distintas en las que se proyectan.
*/
SELECT p.clasificacion, COUNT(DISTINCT f.id_sala) AS total_funciones
FROM funcion f INNER JOIN pelicula p ON f.id_pelicula = p.id
WHERE p.clasificacion IN ('PG', 'PG-13', 'R')
GROUP BY p.clasificacion;

/*
11.- ¿Cuanto tiempo llevaria reproducir todas las peliculas cuyo nombre termine con la letra s, y la duracion sea mayor a 120?

Me faltaba SUM y no se me ocurrio algo bueno.
*/
SELECT SUM(duracion) AS tiempo_total
FROM pelicula
WHERE titulo LIKE '%s' AND duracion > 120;

/*
 *  Consultas José Vicente López López 2212002118
*/

-- 1.- Se desea conocer el id y el nombre de los socios que tienen más de 100 puntos para ofrecerles una promocion especial, limitado a los 10 mejores socios
SELECT id, nombre, paterno, materno, puntos 
FROM socio 
WHERE puntos>100 
ORDER BY puntos DESC
LIMIT 10;

-- 2.- Se quiere obtener una lista unica de peliculas que tengan una duracion myor a 120 minutos y que esten en la sala VIP
SELECT DISTINCT p.titulo, s.categoria
FROM funcion AS f INNER JOIN pelicula AS p ON f.id_pelicula=p.id INNER JOIN sala AS s ON f.id_sala=s.id
WHERE s.categoria='VIP';

-- 3.- Se busca obtener los nombres de los empleados que han realizado ventas en taquilla
SELECT DISTINCT e.id, e.nombre, e.paterno, v.area
FROM venta AS v JOIN empleado AS e ON v.id_empleado=e.id
WHERE v.area='taquilla';

-- 4.- Se desea conocer las funciones programada entre 2 fechas especificas de la semana del 16/09/2024 al 18/09/2024
SELECT p.titulo, f.fecha, f.horario, s.id AS sala
FROM funcion AS f INNER JOIN pelicula AS p ON f.id_pelicula=p.id INNER JOIN sala AS s ON f.id_sala=s.id
WHERE f.fecha BETWEEN '2024-09-16' AND '2024-09-18';

-- 5.- Se desea obtener un conteo del numero de ventas realizadas en cada area del cine para evaluar el desempeño de cada una
SELECT area, COUNT(*) AS 'numero ventas' 
FROM venta
GROUP BY area 
HAVING COUNT(*)>0 
ORDER BY 'numero ventas';

-- 6.- Se desea calcular el total de ingresos obtenidos por las ventas para evaluar la rentabilidad de las areas de venta
SELECT area AS 'Area', SUM(total) AS 'Total Ventas'
FROM venta
GROUP BY area ;

-- 7.- Se desea conocer las salas disponibles para programar nuevas funciones ordenadas de menor a mayor capacidad para optimizar las asignaciones de las peliculas
SELECT s.id AS Sala, s.capacidad
FROM funcion AS f LEFT JOIN sala AS s ON f.id_sala=s.id
ORDER BY s.capacidad ASC;

-- 8.- Se desea conocer las funciones que estan disponibles en el horario de '18:00' y que sea en una sala VIP
SELECT p.titulo, f.horario, s.id AS sala
FROM sala AS s JOIN funcion AS f ON s.id=f.id_sala 
JOIN pelicula AS p ON p.id=f.id_pelicula
WHERE s.categoria='VIP' AND f.horario='18:00';

-- 9.- Se desea calcular la cantidad de boletos vendidos por cada pelicula, para saber que peliculas son las más solicitadas
SELECT p.titulo, COUNT(*) AS 'Total Boletos'
FROM pelicula AS p INNER JOIN funcion AS f ON p.id=f.id_pelicula INNER JOIN boleto AS b ON f.id=b.id_funcion
GROUP BY p.titulo;

-- 10.- Se desea conocer el total de ventas de los empleados de taquilla para darle un bono de productividad al los que tengan los primeros tres lugares
SELECT DISTINCT e.id, e.nombre, e.paterno, e.materno, SUM(v.total) AS Total_venta
FROM empleado AS e
INNER JOIN venta AS v ON e.id = v.id_empleado
WHERE v.area = 'taquilla'
GROUP BY e.id, e.nombre, e.paterno, e.materno
ORDER BY Total_venta DESC
LIMIT 3;

/*
 * Consultas Aldair Oswaldo Avalos Albino 2222005685
*/

-- 1. Se necesita un ranking de los empleados con mas ventas en la dulceria en el mes.
SELECT 
  e.id AS empleado_id, 
  e.nombre, 
  e.paterno, 
  sum(v.total) AS total_venta
FROM venta AS v
  JOIN empleado AS e ON v.id_empleado = e.id
WHERE
  v.area = 'dulceria' AND
  MONTH(v.creada_en) = MONTH(CURDATE()) -- todas las ventas son del mes de septiembre 09
GROUP BY e.id
ORDER BY total_venta DESC;


-- 2. Quiero saber que snacks estan incluidas en cada combo.
SELECT
    c.nombre AS combo_nombre,
    s.nombre AS snack_nombre,
    s.tamanio AS snack_tamanio,
    cs.unidades AS cantidad
FROM combo c
  JOIN combo_snack cs ON c.id = cs.id_combo
  JOIN snack s ON cs.id_snack = s.id
ORDER BY
    c.nombre, s.nombre;

-- 3. Se quiere hacer un reporte de las ventas que indique cuanto se vendia en dulceria cada mes
-- date format para traerte el anio y el mes del atributo creada_en
SELECT 
    DATE_FORMAT(v.creada_en, '%Y-%m') AS mes,
    SUM(
      (vs.cantidad * s.precio) + (vc.cantidad * c.precio)
    ) AS total_vendido
FROM venta AS v
  JOIN venta_snack AS vs ON v.id = vs.id_venta
  JOIN snack AS s ON vs.id_snack = s.id
  JOIN venta_combo AS vc ON v.id = vc.id_venta
  JOIN combo AS c ON c.id = vc.id_combo
GROUP BY mes
ORDER BY mes ASC;


-- 4. Se necesita un ranking con los tres socios que mas han comprado en dulceria a fin de darles boletos gratis al cine.
SELECT
    s.id AS socio_id,
    s.nombre AS socio_nombre,
    s.paterno AS socio_paterno,
    COUNT(v.id) AS total_ventas,
    SUM(v.total) AS total_ingresos
FROM venta v
  JOIN socio s ON v.id_socio = s.id
WHERE v.area = 'dulceria'  
GROUP BY s.id, s.nombre
ORDER BY total_ingresos DESC
LIMIT 3;


-- 5. Se quiere tener una lista de los productos mas vendidos en la dulceria. Ya sea snack o combo.
SELECT 
  s.nombre AS nombre_producto, 
  s.tamanio AS tamanio,
  SUM(vs.cantidad) AS total_vendido
FROM venta_snack AS vs
JOIN snack AS s ON vs.id_snack = s.id
GROUP BY s.id
UNION
SELECT 
    c.nombre AS nombre_producto, 
    NULL AS tamanio_combo,
    SUM(vc.cantidad) AS total_vendido
FROM venta_combo AS vc
JOIN combo AS c ON vc.id_combo = c.id
GROUP BY c.id
ORDER BY total_vendido DESC;

-- 6. El socio que mas ha gastado en dulceria
SELECT s.id AS socio_id, SUM(v.total) AS total_gastado
FROM venta AS v 
  JOIN socio s ON v.id_socio = s.id
WHERE v.area = 'dulceria'  
GROUP BY s.id
ORDER BY total_gastado DESC LIMIT 1;

-- 7. Encuentra las ventas de dulceria del socio que mas ha gastado.
-- Como el socio que mas ha gastado es el socio NULL, es decir los clientes que aun no se registran como socio, se tiene que hacer OFFSET 1 para encontrar el segundo socio que mas ha gastado.
SELECT 
  v.id AS venta_id,
  total, 
  creada_en, 
  metodo_pago
FROM venta v
WHERE v.id_socio = (
    SELECT v2.id_socio FROM venta AS v2
    WHERE v2.area = 'dulceria'
    GROUP BY v2.id_socio
    ORDER BY SUM(v2.total) DESC
    LIMIT 1 OFFSET 1
);

-- 8. Muestra las snacks que NO estan incluidas en ningun combo
SELECT s.* FROM snack AS s
LEFT JOIN combo_snack cs ON s.id = cs.id_snack
WHERE cs.id_snack IS NULL;

-- 9. Cuenta el total de ventas entre un rango de dias.
SELECT COUNT(*) AS total_ventas
FROM venta AS v WHERE v.creada_en BETWEEN '2024-09-16' AND '2024-09-17';

-- 10. Busca las ventas de los socios cuyos nombres empiezen con alter
SELECT 
    s.nombre, s.paterno, 
    v.id_socio,
    v.creada_en,
    v.metodo_pago
FROM venta AS v JOIN socio AS s ON v.id_socio = s.id
WHERE s.paterno LIKE 'A%';
