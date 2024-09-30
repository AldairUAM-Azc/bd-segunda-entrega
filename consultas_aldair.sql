-- 1. Se necesita un ranking de los empleados con mas ventas en la dulceria en el mes
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
