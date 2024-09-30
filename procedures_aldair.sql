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
