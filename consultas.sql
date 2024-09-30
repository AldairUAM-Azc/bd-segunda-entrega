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
5.- ¿cuántas funciones están programadas por idioma? Se requiere listar solo aquellos idiomas que tienen menos de tres funciones.
*/
SELECT idioma, COUNT(*) AS cantidad_funciones
FROM  funcion
GROUP BY idioma  HAVING  COUNT(*) < 3;

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
