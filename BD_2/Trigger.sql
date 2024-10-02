

use cinetubi;
/*Bitabora*/
CREATE TABLE bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion VARCHAR(20) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    valores_anteriores MEDIUMTEXT,
    valores_nuevos MEDIUMTEXT,
    usuario_aplicacion VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Triggers  Hernández Aguilar Jonathan Abraham 2182004371

DELIMITER //

CREATE TRIGGER limitar_peliculas
BEFORE INSERT ON funcion
FOR EACH ROW
BEGIN
    DECLARE total_funciones INT;
    
    SELECT COUNT(*) INTO total_funciones 
    FROM funcion 
    WHERE id_pelicula = NEW.id_pelicula;

    IF total_funciones > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden programar más de 10 funciones para cada película.';
    END IF;
END;

DELIMITER ;

/*
 *Triggers José Vicente López López 2212002118
*/
-- Trigger Agregar Venta
DELIMITER //
CREATE TRIGGER ventaAI
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('INSERT', 'venta', null,
            CONCAT(NEW.id, ':', NEW.id_empleado, ':', NEW.id_socio, ':', NEW.total, ':',NEW.creada_en, ':', NEW.metodo_pago, ':', NEW.area), 
            USER());
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER venta_AD
AFTER DELETE ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('DELETE', 
			'venta',
            CONCAT(OLD.id, ':', OLD.id_empleado, ':', OLD.id_socio, ':', OLD.total, ':',OLD.creada_en, ':', OLD.metodo_pago, ':', OLD.area), 
            null,
            USER());
END //
DELIMITER ;

DROP  TRIGGER venta_AU;
DELIMITER //
CREATE TRIGGER venta_AU
BEFORE UPDATE ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('UPDATE', 'venta', 
			CONCAT(OLD.id, ':', OLD.id_empleado, ':', OLD.id_socio, ':', OLD.total, ':',OLD.creada_en, ':', OLD.metodo_pago, ':', OLD.area), 
            CONCAT(NEW.id, ':', NEW.id_empleado, ':', NEW.id_socio, ':', NEW.total, ':',NEW.creada_en, ':', NEW.metodo_pago, ':', NEW.area), 
            USER());
END //
DELIMITER ;

 -- Pruebas VICENTE
INSERT INTO venta (id_empleado, id_socio, metodo_pago, area, total, creada_en) VALUES
(1, 5, 'credito', 'taquilla', 230, '2024-09-30 20:30:15');
UPDATE venta SET total=9999 WHERE id=43;
DELETE FROM venta where id=42;
SELECT * FROM bitacora;

/*
 * Triggers Aldair Oswaldo Avalos Albino 2222005685
*/

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


