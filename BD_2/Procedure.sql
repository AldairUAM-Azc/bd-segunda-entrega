-- *********************************************************************
-- Procedure
-- *********************************************************************
use cinetubi;
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


-- DROP PROCEDURE agregar_funcion;

-- Inserts para probar la lógica del Negocio
CALL agregar_funcion(1, '2024-10-01', '12:00:00', 2, 'Español'); -- Intentando añadir una funcion en sala en mantenimiento
CALL agregar_funcion(5, '2024-09-16', '18:00:00', 1, 'Español'); -- Añadiendo una funcion cuando ya hay asignadas funciones a esa hora en esa sala
CALL agregar_funcion(2, '2024-10-01', '15:00:00', 11, 'Español'); -- Añadiendo una funcion no apta para niños en sala para niños
CALL agregar_funcion(2, '2024-10-01', '9:00:00', 1, 'Español'); -- Añadiendo una funcion mal horario (temprano)
CALL agregar_funcion(2, '2024-10-01', '23:00:00', 1, 'Español'); -- Añadiendo una funcion mal horario (tarde)
CALL agregar_funcion(3, '2024-10-01', '15:00:00', 11, 'Español'); -- Añadiendo una funcion que pasa todos los filtros


-- José Vicente López López 2212002118
-- Se debe realizar una venta de boleto con un procedure, ya que al hacerce la venta, tambien se realiza un boleto y antes de boleto se debe realizar una venta
DELIMITER //
CREATE PROCEDURE agregar_boleto (
	IN p_id_empleado INT,
    IN p_id_socio INT,
    IN p_total DECIMAL(10,2),
    IN p_creada_en DATETIME,
    IN p_metodo_pago VARCHAR(50),
    IN p_id_funcion INT,
    IN p_num_boleto INT
)
BEGIN
	DECLARE v_asiento_ocupado INT;
    DECLARE p_id_venta INT;
    DECLARE a_ocupados INT;
    DECLARE a_capacidad INT;
	INSERT INTO venta (id_empleado, id_socio, metodo_pago, area, total, creada_en) VALUES
				(p_id_empleado, p_id_socio, p_metodo_pago, 'taquilla', p_total,  p_creada_en);
                
	SELECT COUNT(*) INTO a_ocupados FROM boleto WHERE id_funcion=p_id_funcion;
	SELECT s.capacidad INTO a_capacidad FROM funcion AS f JOIN sala AS s ON f.id_sala=s.id WHERE f.id= p_id_funcion;
    
	SELECT MAX(id) INTO p_id_venta FROM venta WHERE area='taquilla';
    -- Verificar si el asiento ya está ocupado para la función
    SELECT COUNT(*) INTO v_asiento_ocupado
    FROM boleto
    WHERE id_funcion = p_id_funcion AND num_boleto = p_num_boleto; -- Asegúrate de que la columna existe en boleto
    -- Comprobar si el asiento está ocupado
    IF a_capacidad=a_ocupados THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay asientos disponibles';
    ELSEIF v_asiento_ocupado = 0 THEN
        -- Insertar el boleto
        INSERT INTO boleto (id_funcion, id_venta, num_boleto)
        VALUES (p_id_funcion, p_id_venta, p_num_boleto);
        
        SELECT 'Boleto agregado exitosamente.' AS mensaje;
    ELSE
        SELECT 'Error: El asiento ya está ocupado para esta función.' AS mensaje;
    END IF;
END //

DELIMITER ;
-- DROP PROCEDURE agregar_boleto;
CALL agregar_boleto(7,null, 150, '2024-09-30 02:44:15', 'credito', 2, 30); -- Se agrega correctamente
-- CALL agregar_boleto(7,null, 150, '2024-09-30 02:44:15', 'credito', 2, 30); -- Marca error puesto que ya esta ocupado ese asiento en esa sala para esa funcion


/*
 * Consultas Aldair Oswaldo Avalos Albino 2222005685
*/
-- Inserta un registro en venta_snack dados un id_venta, un id_snack y una cantidad. Se valida que tanto como la venta como el snack existan.
-- p_ es parametro, v_ es variable

DELIMITER //
CREATE PROCEDURE agregar_snack_a_venta (
    IN p_id_venta INT,
    IN p_id_snack INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_existe_venta INT;
    DECLARE v_existe_snack INT;
    DECLARE v_venta_area VARCHAR(30);

    -- Verificar si la venta existe
    SELECT id INTO v_existe_venta
    FROM venta
    WHERE id = p_id_venta;

    -- Verificar si el snack existe
    SELECT id INTO v_existe_snack
    FROM snack
    WHERE id = p_id_snack;
    
    -- Verificar si la venta es de dulceria
    SELECT area INTO v_venta_area
    FROM venta
    WHERE id = p_id_venta;

    -- Validar la existencia de la venta y el snack
    IF v_existe_venta IS NULL OR v_venta_area NOT IN ('dulceria') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La venta no existe o no es una venta del area de dulceria.';
    ELSEIF v_existe_snack IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El snack no existe.';
    ELSE
        -- Insertar el registro en venta_snack
        INSERT INTO venta_snack (id_venta, id_snack, cantidad)
        VALUES (p_id_venta, p_id_snack, p_cantidad);
    END IF;
END //
DELIMITER ;

-- la view me ayuda a ver que no hay chocolate en la venta 37
SELECT * FROM vista_ventas_detalladas;
SELECT * FROM snack;
SELECT * FROM venta WHERE area = 'dulceria';

-- se agrega sin problemas
CALL agregar_snack_a_venta(37, 10, 3);
SELECT * FROM venta_snack;

-- venta 1 no es de dulceria
CALL agregar_snack_a_venta(1, 10, 3);

-- snack 15 no existe
CALL agregar_snack_a_venta(37, 15, 3);
