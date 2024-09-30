-- Muestra la informacion de las ventas, que snacks se compraron y que combos, ya no es necesario hacer todos los joins cada vez.
CREATE OR REPLACE VIEW vista_ventas_detalladas AS
SELECT 
    v.id AS id_venta,
    v.creada_en AS fecha_venta,
    v.metodo_pago AS metodo_pago,
    e.nombre AS empleado_nombre,
    s.nombre AS snack_nombre,
    s.tamanio AS snack_tamanio,
    s.precio AS snack_precio,
    vs.cantidad AS snack_cantidad,
    c.nombre AS combo_nombre,
    c.precio AS combo_precio,
    vc.cantidad AS combo_cantidad,
    v.total AS total_de_venta
FROM venta AS v
LEFT JOIN venta_snack AS vs ON v.id = vs.id_venta
LEFT JOIN snack AS s ON vs.id_snack = s.id
LEFT JOIN venta_combo AS vc ON v.id = vc.id_venta
LEFT JOIN combo AS c ON vc.id_combo = c.id
JOIN empleado AS e ON v.id_empleado = e.id
WHERE v.area = 'dulceria'; -- se necesitan los LEFT JOIN en la vista para mostrar como null los combos y las snacks que no aparecen en algunas ventas

SELECT * FROM vista_ventas_detalladas;
