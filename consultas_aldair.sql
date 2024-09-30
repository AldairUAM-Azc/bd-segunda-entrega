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
