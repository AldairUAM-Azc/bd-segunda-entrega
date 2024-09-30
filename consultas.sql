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
5.- Contar cuántas películas hay de cada clasificación por distribuidor, mostrando solo distribuidoras que tienen más de 3 películas clasificación "R".
*/
SELECT d.nombre, p.clasificacion, COUNT(*) AS total_peliculas
FROM distribuidor d
JOIN pelicula p ON d.id = p.distribuidor
GROUP BY d.id, p.clasificacion
HAVING p.clasificacion = 'R' AND COUNT(*) > 3;



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
 *José Vicente López López
 *Consultas
*/

-- 1.- Se desea conocer el id y el nombre de los socios que tienen más de 100 puntos para ofrecerles una promocion especial, limitado a los 10 mejores socios
SELECT id, nombre, paterno, materno, puntos 
FROM socio 
WHERE puntos>100 
ORDER BY puntos DESC;

-- 2.- Se quiere obtener una lista unica de peliculas que tengan una duracion myor a 120 minutos y que esten en la sala VIP
SELECT DISTINCT p.titulo, s.categoria
FROM funcion AS f INNER JOIN pelicula AS p ON f.id_pelicula=p.id INNER JOIN sala AS s ON f.id_sala=s.id
WHERE s.categoria='VIP';

-- 3.- Se busca obtener los nombres de los empleados que pertenecen a la categoria  taquillero
SELECT e.id, e.nombre, e.paterno
FROM venta AS v INNER JOIN empleado AS e ON v.id_empleado=e.id
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

-- 6.- Se desea calcular el total de ingresos obtenidos por las ventas de boletos para evaluar la rentabilidad de las areas de venta
SELECT area AS 'Area', SUM(total) AS 'Total Ventas'
FROM venta
GROUP BY area;

-- 7.- Se desea conocer las salas disponibles para programar nuevas funciones ordenadas de menor a mayor capacidad para optimizar las asignaciones de las peliculas
SELECT s.id AS Sala
FROM funcion AS f LEFT JOIN sala AS s ON f.id_sala=s.id
WHERE horario='18:00'
ORDER BY s.capacidad DESC;

-- 8.- Se desea obtener el estado de todos los asientos de una sala especifica para verificar la disponibilidad antes de programar funciones
SELECT s.id AS Sala, a.estado, COUNT(*) AS cantidad
FROM sala AS s INNER JOIN asiento AS a ON s.id = a.id_sala
WHERE s.categoria='VIP'
GROUP BY s.id, a.estado;

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
