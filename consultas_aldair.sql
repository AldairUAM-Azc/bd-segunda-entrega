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
    cs.quantity AS cantidad
FROM combo c
  JOIN combo_snack cs ON c.id = cs.id_combo
  JOIN snack s ON cs.id_snack = s.id
ORDER BY
    c.nombre, s.nombre;
