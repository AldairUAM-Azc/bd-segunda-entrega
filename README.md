# FALTAN LAS MODIFICACIONES DE LA PRIMERA ENTREGA

- [ ] Revisar los checks de los atributos
  - [X] sala.capacidad entre 0 y 50
  - [X] sala.categoria IN VIP Standard Premium
- [ ] Dejar pelicula en 3FN. Separar pelicula en distribuidores y directores
- [ ] Meterle 50 registros a las tablas que se puedan

# 🗃️ BD Proyecto Final. Segunda Entrega

## 🔍 Consultas en SQL

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

Cada vista deberá tener por lo menos 3 Tablas relacionadas.

Entregables:

- [ ] Un Script que contenga la vista creada por el alumno.
- [ ] Incluir en el diagrama relacional de la primera entrega una indicación o selección de
las tablas utilizadas en la vista implementada. Se debe entregar un diagrama por cada
integrante del equipo

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

