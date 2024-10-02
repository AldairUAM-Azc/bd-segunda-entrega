DROP TRIGGER actualizar_stock_snack;
DELIMITER //
CREATE TRIGGER actualizar_stock_snack
BEFORE INSERT ON venta_snack
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    
    -- Traete el stock hasta este momento
    SELECT stock INTO stock_actual 
    FROM snack 
    WHERE id = NEW.id_snack;
    
    -- Verificar si el stock_actual es suficiente para entregar lo que se pide
    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock para completar la venta';
    ELSE
        -- Reducir el stock de snack
        UPDATE snack
        SET stock = stock - NEW.cantidad
        WHERE id = NEW.id_snack;
    END IF;
END; //
DELIMITER ;

INSERT INTO venta_snack (id_venta, id_snack, cantidad) VALUES
(26, 11, 4); -- inserto a la venta 26, 4 unidades del snack 11, las galletas.

SELECT * FROM snack; -- se muestra como el stock de galletas se redujo de 100 a 96



-- Para actualizar los totales de las ventas
-- DROP PROCEDURE actualizar_total_venta;
DELIMITER //
CREATE PROCEDURE actualizar_total_venta(IN p_id_venta INT)
BEGIN
	DECLARE v_es_venta_dulceria VARCHAR(50);
    DECLARE v_total_snacks DECIMAL(10, 2);
    DECLARE v_total_combos DECIMAL(10, 2);
    DECLARE v_total DECIMAL(10, 2);
    
    -- Checar si la venta es de dulceria
    SELECT area INTO v_es_venta_dulceria
    FROM venta WHERE id = p_id_venta;
    IF v_es_venta_dulceria != 'dulceria' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La venta no es del area de dulceria';
    END IF;
    
	-- Sumar el total de los snacks
	SELECT SUM(s.precio * vs.cantidad) INTO v_total_snacks
	FROM venta_snack vs
	JOIN snack s ON vs.id_snack = s.id
	WHERE vs.id_venta = p_id_venta;

	-- Sumar el total de los combos (suponiendo que cada combo tiene un precio fijo)
	SELECT SUM(c.precio * vc.cantidad) INTO v_total_combos
	FROM venta_combo vc
	JOIN combo c ON vc.id_combo = c.id
	WHERE vc.id_venta = p_id_venta;

	-- Calcular el total total
	SET v_total = IFNULL(v_total_snacks, 0) + IFNULL(v_total_combos, 0);

	-- Actualizar el total en la tabla venta
	UPDATE venta
	SET total = v_total
	WHERE id = p_id_venta;
END //
DELIMITER ;

CALL actualizar_total_venta(4);
SELECT * FROM venta;

SELECT SUM(s.precio * vs.cantidad) 
	FROM venta_snack vs
	JOIN snack s ON vs.id_snack = s.id
	WHERE vs.id_venta = 4;
    
SELECT SUM(c.precio * vc.cantidad)
	FROM venta_combo vc
	JOIN combo c ON vc.id_combo = c.id
	WHERE vc.id_venta = 4;
    


-- DROP PROCEDURE actualizar_todas_las_ventas;
DELIMITER //
CREATE PROCEDURE actualizar_todas_las_ventas()
BEGIN
    DECLARE v_id_venta INT;
    DECLARE v_area VARCHAR(50);

    -- Cursor para seleccionar todas las ventas
    DECLARE venta_cursor CURSOR FOR
        SELECT id FROM venta;

    -- Manejo de excepciones
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id_venta = NULL;

    -- Abrir el cursor
    OPEN venta_cursor;

    -- Bucle para procesar cada venta
    read_loop: LOOP
        FETCH venta_cursor INTO v_id_venta;
        
        IF v_id_venta IS NULL THEN
            LEAVE read_loop;
        END IF;

        -- Obtener el área de la venta
        SELECT area INTO v_area
        FROM venta
        WHERE id = v_id_venta;

        -- Verificar si la venta es de dulcería
        IF v_area = 'dulcería' THEN
            -- Llamar al procedimiento para actualizar el total de la venta
            CALL actualizar_total_venta(v_id_venta);
        END IF;
    END LOOP;

    -- Cerrar el cursor
    CLOSE venta_cursor;
END //
DELIMITER ;

CALL actualizar_todas_las_ventas();
SELECT * FROM venta WHERE area='dulceria';
