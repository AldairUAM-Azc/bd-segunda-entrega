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
