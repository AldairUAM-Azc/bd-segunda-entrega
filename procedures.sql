
-- Procedure  Hernández Aguilar Jonathan Abraham 2182004371

DELIMITER //

CREATE PROCEDURE agregar_funcion(
    IN p_id_pelicula INT,
    IN p_fecha DATE,
    IN p_horario TIME,
    IN p_id_sala INT,
    IN p_idioma VARCHAR(30)
)
BEGIN
    DECLARE sala_estado VARCHAR(50);
    DECLARE categoria_pelicula VARCHAR(10);
    DECLARE duracion_pelicula INT;
	DECLARE fin_horario TIME;

    -- Verificar el estado de la sala
    SELECT estado INTO sala_estado FROM sala WHERE id = p_id_sala;

    -- Verificar la categoría de la película
    SELECT clasificacion INTO categoria_pelicula FROM pelicula WHERE id = p_id_pelicula;

    -- Obtener la duración de la película
    SELECT duracion INTO duracion_pelicula FROM pelicula WHERE id = p_id_pelicula;

    -- Calcular el horario de finalización

    SET fin_horario = ADDTIME(p_horario, SEC_TO_TIME((duracion_pelicula + 20) * 60));

    -- Condiciones para insertar la función
    IF sala_estado = 'mantenimiento' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar la función: la sala está en mantenimiento.';
    ELSEIF (categoria_pelicula != 'R') AND (p_id_sala IN (SELECT id FROM sala WHERE categoria = 'Junior')) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar la función: la categoría de la película no es apta para niños pequeños en salas Junior.';
    ELSEIF (p_horario < '10:00:00' OR p_horario > '22:30:00') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar la función: el horario debe estar entre 10:00 y 22:30.';
    ELSEIF (
        SELECT COUNT(*) 
        FROM funcion 
        WHERE id_sala = p_id_sala 
        AND fecha = p_fecha 
        AND (
            (p_horario BETWEEN horario AND ADDTIME(horario, SEC_TO_TIME(duracion_pelicula * 60))) OR 
            (fin_horario BETWEEN horario AND ADDTIME(horario, SEC_TO_TIME(duracion_pelicula * 60))) OR 
            (horario BETWEEN p_horario AND fin_horario)
        )
    ) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede agregar la función: ya hay una función en la misma sala a la misma hora.';
    ELSE
        -- Si se cumplen todas las condiciones, insertar la función
        INSERT INTO funcion (id_pelicula, fecha, horario, id_sala, idioma)
        VALUES (p_id_pelicula, p_fecha, p_horario, p_id_sala, p_idioma);
    END IF;
END //

DELIMITER ;



-- DROP PROCEDURE agregar_funcion;
select * FROM sala;
select * FROM pelicula;
select * FROM funcion;

-- Inserts para probar la lógica del Negocio
CALL agregar_funcion(1, '2024-10-01', '12:00:00', 9, 'Español'); -- Intentando añadir una funcion en sala en mantenimiento
CALL agregar_funcion(5, '2024-10-01', '15:00:00', 1, 'Español'); -- Añadiendo una funcion cuando ya hay asignadas funciones a esa hora en esa sala
CALL agregar_funcion(2, '2024-10-01', '15:00:00', 8, 'Español'); -- Añadiendo una funcion no apta para niños en sala para niños
CALL agregar_funcion(2, '2024-10-01', '9:00:00', 1, 'Español'); -- Añadiendo una funcion mal horario (temprano)
CALL agregar_funcion(2, '2024-10-01', '23:00:00', 1, 'Español'); -- Añadiendo una funcion mal horario (tarde)
CALL agregar_funcion(3, '2024-10-01', '15:00:00', 8, 'Español'); -- Añadiendo una funcion que pasa todos los filtros

