# FALTAN LAS MODIFICACIONES DE LA PRIMERA ENTREGA

- [ ] Revisar los checks de los atributos
  - [X] sala.capacidad entre 0 y 30
  - [X] sala.categoria IN VIP Standard Premium
- [ ] Dejar pelicula en 3FN. Separar pelicula en distribuidores y directores
- [ ] Meterle 50 registros a las tablas que se puedan

# 🗃️ BD Proyecto Final. Segunda Entrega

## 🔍 Consultas en SQL

### Jonathan
1. Muestra el nombre de la pelicula, duracion y clasificacion de las peliculas cuyo titulo empiecen con "The" y la duración esté entre 90 y 120 minutos.
2.  Se quiere conocer la duración promedio de las películas distribuidas por cada distribuidor, pero solo para aquellos distribuidores cuya duración promedio sea mayor a 100 minutos.
3.  ¿Cual es la funcion mas tarde que hay, en que idioma esta, y cual es su director y distribuidor?
4.   Se necesita saber cuantas funciones hay y en que idioma estan dichas funciones.
5.   Contar cuántas películas hay de cada clasificación por distribuidor, mostrando solo distribuidoras que tienen más de 3 películas clasificación "R".
6.   En una revisión, necesitan saber cuales fueron las ultimas 15 funciones programadas. Neceitan ver el nombre de la pelicula y los datos de la funcion tales como fecha, hora y sala.
7.   Se quiere  una vista general de las peliculas del cine, para ello se requiere ver una tabla con el nombre de la pelicula, nombre del director (una sola celda), nombre de la distribuidora, ademas de saber la clasificacion de las peliculas
8.   Muestra todos los registros de la tabla pelicula, incluyendo aquellas que no tienen asignado un distribuidor y/o director.  Se debe mostrar el título de la película, el nombre del distribuidor (si está disponible) y el nombre del director (si está disponible).
9.   Se requiere saber el nombre del distribuidor y las películas que han distribuido.  Es importante incluir también aquellos distribuidores que no tienen películas asociadas. La consulta debe mostrar el nombre del distribuidor, el título de la película (si existe) y la duración de la película (si existe).
10.   Calcular la cantidad total de funciones programadas para películas que tengan clasificaciones específicas, como "PG", "PG-13" y "R" considerando solo las salas distintas en las que se proyectan.
11.   ¿Cuanto tiempo llevaria reproducir todas las peliculas cuyo nombre termine con la letra s, y la duracion sea mayor a 120?

---

### Vicente

1. Se desea conocer el id y el nombre de los socios que tienen más de 100 puntos para ofrecerles una promocion especial, limitado a los 10 mejores socios
2. Se quiere obtener una lista unica de peliculas que tengan una duracion myor a 120 minutos y que esten en la sala VIP SELECT DISTINCT p.titulo, s.categoria
3. Se busca obtener los nombres de los empleados que pertenecen a la categoria  taquillero
4. Se desea conocer las funciones programada entre 2 fechas especificas de la semana del 16/09/2024 al 18/09/2024
5. Se desea obtener un conteo del numero de ventas realizadas en cada area del cine para evaluar el desempeño de cada una SELECT area, COUNT(*) AS 'numero ventas'
6. Se desea calcular el total de ingresos obtenidos por las ventas de boletos para evaluar la rentabilidad de las areas de venta
7. Se desea conocer las salas disponibles para programar nuevas funciones ordenadas de menor a mayor capacidad para optimizar las asignaciones de las peliculas
8. Se desea obtener el estado de todos los asientos de una sala especifica para verificar la disponibilidad antes de programar funciones
9. Se desea calcular la cantidad de boletos vendidos por cada pelicula, para saber que peliculas son las más solicitadas
10. Se desea conocer el total de ventas de los empleados de taquilla para darle un bono de productividad al los que tengan los primeros tres lugares

---
### Aldair

   






La consulta debe mostrar el nombre del distribuidor y su duración promedio de las películas.
Cada integrante del equipo debe realizar 10 consultas, sin repetir ninguna, utilizando:
  - DISTINCT, ORDER BY, LIMIT
  - WHERE, GROUP BY, HAVING, IN, BETWEEN, LIKE
  - SUM, AVG, COUNT, MAX, MIN
  - JOIN (INNER, LEFT, RIGHT)
  - Subconsultas
    
Entregables:

  - [ ] Un documento con las consultas realizadas en lenguaje natural
  - [ ] Un Script con las consultas traducidas a SQL.

## 📊 Vistas

Se deberá incluir una vista por cada integrante del equipo:

Cada vista deberá tener por lo menos 3 Tablas relacionadas. La pura vista nada mas, en la evaluaciòn 

Entregables:

- [ ] Un Script que contenga la vista creada por el alumno.
- [ ] Incluir en el diagrama relacional de la primera entrega una indicación o selección de
las tablas utilizadas en la vista implementada. Se debe entregar un diagrama por cada
integrante del equipo. El diagrama pata de gallo completo de la primera entrega, identificando las tablas que cada quien uso en sus vistas.

## 🔫 Triggers

Crear Triggers para realizar la automatización de una bitácora.

- Crear una Tabla log o bitácora **(una tabla por todo el equipo)** que contenga por lo menos los siguientes atributos:
  - tipo de operación
  - Tabla a la que se le aplica la operación
  - número de registro modificado
  - valores anteriores
  - valores nuevos
  - usuario que aplica los cambios,
  - fecha y hora cuando se realizan los cambios

- Crear los triggers necesarios para registrar en la bitácora los eventos de UPDATE,
INSERT, y DELETE realizados en una tabla crítica. **(Cada uno usa una tabla critica diferente)**

Cada integrante del equipo debe crear un trigger que implemente una regla de negocio
que no pueda ser fácilmente representada mediante restricciones de integridad.
Además, se debe proporcionar una justificación para dicha implementación.

Entregables:

- [ ] Tabla bitácora
- [ ] Un Script con los Triggers implementados y probados.

## 📦 Procedimientos almacenados

Crear un procedimiento almacenado para realizar consultas complejas y recurrentes. Cada integrante del equipo debe entregar un procedimiento almacenado.

Ejemplos:

• Un procedimiento que ejecute una consulta compleja y genere un reporte basado en múltiples
tablas, devolviendo un conjunto de resultados.

• Un procedimiento que calcule estadísticas, como promedio, máximo y mínimo, a partir de
los datos de una tabla.

• Un procedimiento que inserte un registro en una tabla, realizando validaciones o cálculos
previos antes de la inserción

Entregables:

- [ ] Un Script con los procedimientos almacenados implementados y probados.

