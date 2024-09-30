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

