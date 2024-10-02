/*
DROP TABLE bitacora;
DROP TRIGGER bitacora_AI_venta;
DROP TRIGGER bitacora_AU_venta;
DROP TRIGGER bitacora_AD_venta;
*/

CREATE TABLE bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion VARCHAR(20) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    valores_anteriores MEDIUMTEXT,
    valores_nuevos MEDIUMTEXT,
    usuario_aplicacion VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

/*José Vicente López López*/
-- Trigger bitacora para tabla venta
-- INSERT
DELIMITER //
CREATE TRIGGER bitacora_AI_venta
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('INSERT', 'venta', NEW.id,
			null,
            CONCAT(NEW.id, ';', NEW.id_empleado, ';', IFNULL(NEW.id_socio,'NULL'), ';', NEW.total, ';',NEW.creada_en, ';', NEW.metodo_pago, ';', NEW.area), 
            USER());

END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER bitacora_AU_venta
AFTER UPDATE ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('UPDATE', 'venta', NEW.id, 
			CONCAT(OLD.id, ';', OLD.id_empleado, ';', IFNULL(OLD.id_socio,'NULL'), ';', OLD.total, ';',OLD.creada_en, ';', OLD.metodo_pago, ';', OLD.area),
			CONCAT(NEW.id, ';', NEW.id_empleado, ';', IFNULL(NEW.id_socio,'NULL'), ';', NEW.total, ';',NEW.creada_en, ';', NEW.metodo_pago, ';', NEW.area),
            USER());

END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER bitacora_AD_venta
AFTER DELETE ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('DELETE', 'venta', OLD.id, 
			CONCAT(OLD.id, ';', OLD.id_empleado, ';', OLD.id_socio, ';', OLD.total, ';',OLD.creada_en, ';', OLD.metodo_pago, ';', OLD.area),
            null, 
            USER());

END //
DELIMITER ;


 -- Ejemplo INSERT en venta
INSERT INTO venta (id_empleado, id_socio, metodo_pago, area, total, creada_en) VALUES
(1, 5, 'credito', 'taquilla', 230, '2024-09-30 20:30:15');
SELECT * FROM venta;
SELECT * FROM bitacora;

 -- Ejemplo UPDATE en venta
UPDATE venta SET id_empleado = 3, id_socio = NULL , metodo_pago = 'efectivo' WHERE id = LAST_INSERT_ID();
SELECT * FROM venta;
SELECT * FROM bitacora;


 -- Ejemplo DELETE en venta
DELETE FROM venta WHERE id = LAST_INSERT_ID();
SELECT * FROM venta;
SELECT * FROM bitacora;

