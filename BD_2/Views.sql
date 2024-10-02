-- *********************************************************************
-- Views
-- *********************************************************************
use cinetubi;
-- Vista Hernández Aguilar Jonathan Abraham 2182004371
CREATE VIEW vista_funcion AS SELECT 
    p.titulo, p.duracion, p.clasificacion, CONCAT(d.nombre, " ", d.apellido) AS director,
    dist.nombre AS distribuidor, f.fecha, f.horario, f.idioma, s.categoria AS categoria_sala,
    s.capacidad AS capacidad_sala
FROM pelicula p
LEFT JOIN director d ON p.director = d.id
LEFT JOIN distribuidor dist ON p.distribuidor = dist.id
INNER JOIN funcion f ON p.id = f.id_pelicula
INNER JOIN sala s ON f.id_sala = s.id;

SELECT * FROM vista_funcion;

-- José Vicente López López
-- Se desea conocer las ventas que se han hecho, quien la ha hecho y una breve descripcion de la funcion, asi como el asiento y la sala.
CREATE VIEW V_B_E_F_P_S AS
SELECT v.id AS id_venta, e.nombre AS nombre_empleado, p.titulo AS pelicula_titulo, f.horario AS funcion_horario, b.num_boleto, s.id AS sala, s.categoria AS categoria_sala, f.idioma AS idioma
FROM venta AS v INNER JOIN boleto AS b ON v.id=b.id_venta
INNER JOIN funcion AS f ON b.id_funcion=f.id
INNER JOIN pelicula AS p ON f.id_pelicula=p.id
INNER JOIN sala AS s ON f.id_sala=s.id
INNER JOIN empleado AS e ON v.id_empleado=e.id;

SELECT * FROM V_B_E_F_P_S;

/*
 * Vistas Aldair Oswaldo Avalos Albino 2222005685
*/
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