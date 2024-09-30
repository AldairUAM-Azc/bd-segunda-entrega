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

/*José Vicente Lopez Lopez*/

-- Se desea conocer las ventas que se han hecho, quien la ha hecho y una breve descripcion de la funcion, asi como el asiento y la sala.
CREATE VIEW V_B_E_F_P_S AS
SELECT  v.id AS id_venta, e.nombre AS nombre_empleado, p.titulo AS pelicula_titulo, f.horario AS funcion_horario, 
        b.num_boleto, s.id AS sala, s.categoria AS categoria_sala, f.idioma AS idioma
FROM venta AS v INNER JOIN boleto AS b ON v.id=b.id_venta
INNER JOIN funcion AS f ON b.id_funcion=f.id
INNER JOIN pelicula AS p ON f.id_pelicula=p.id
INNER JOIN sala AS s ON f.id_sala=s.id
INNER JOIN empleado AS e ON v.id_empleado=e.id;

SELECT * FROM V_B_E_F_P_S;
