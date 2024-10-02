/*
DROP TABLE bitacora;
DROP TRIGGER bitacora_AI_venta;
DROP TRIGGER bitacora_AU_venta;
DROP TRIGGER bitacora_AD_venta;
DROP TRIGGER bitacora_AI_pelicula;
DROP TRIGGER bitacora_AU_pelicula;
DROP TRIGGER bitacora_AD_pelicula;
DROP TRIGGER bitacora_AI_empleado;
DROP TRIGGER bitacora_AU_empleado;
DROP TRIGGER bitacora_AD_empleado;
*/

CREATE TABLE bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion VARCHAR(20) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    id_registro_afectado INT NOT NULL,
    valores_anteriores MEDIUMTEXT,
    valores_nuevos MEDIUMTEXT,
    usuario_aplicacion VARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- **********************************************************************************
/* José Vicente López López */
-- Trigger bitacora para tabla venta
-- **********************************************************************************
-- INSERT
DELIMITER //
CREATE TRIGGER bitacora_AI_venta
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
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

-- **********************************************************************************
/* Jonathan Hernandez */
-- Trigger bitacora para tabla pelicula
-- **********************************************************************************
-- Trigger bitacora para tabla pelicula
-- INSERT
DELIMITER //
CREATE TRIGGER bitacora_AI_pelicula
AFTER INSERT ON pelicula
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('INSERT', 'pelicula', NEW.id,
			null,
            CONCAT(NEW.id, ';', NEW.titulo, ';', NEW.distribuidor, ';', NEW.clasificacion, ';',NEW.director, ';', NEW.descripcion), 
            USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER bitacora_AU_pelicula
AFTER UPDATE ON pelicula
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('UPDATE', 'pelicula', NEW.id, 
			CONCAT(OLD.id, ';', OLD.titulo, ';', OLD.distribuidor, ';', OLD.clasificacion, ';',OLD.director, ';', OLD.descripcion), 
			CONCAT(NEW.id, ';', NEW.titulo, ';', NEW.distribuidor, ';', NEW.clasificacion, ';',NEW.director, ';', NEW.descripcion), 
            USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER bitacora_AD_pelicula
AFTER DELETE ON pelicula
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('DELETE', 'pelicula', OLD.id, 
			CONCAT(OLD.id, ';', OLD.titulo, ';', OLD.distribuidor, ';', OLD.clasificacion, ';',OLD.director, ';', OLD.descripcion), 
            null, 
            USER());
END //
DELIMITER ;


 -- Ejemplo INSERT en pelicula
INSERT INTO pelicula (titulo, duracion, distribuidor, clasificacion, director, descripcion) VALUES
('Arrancame la vida', 107, 2, 'R', 5, 'La historia de enmacipacion de una mujer poblana de clase baja.');
SELECT * FROM pelicula;
SELECT * FROM bitacora;

 -- Ejemplo UPDATE en pelicula
UPDATE pelicula SET duracion = 120, clasificacion = 'PG-13', descripcion = 'Catalina lucha por encontrar su libertad e identidad.' WHERE id = LAST_INSERT_ID();
SELECT * FROM pelicula;
SELECT * FROM bitacora;

 -- Ejemplo DELETE en pelicula
DELETE FROM pelicula WHERE id = LAST_INSERT_ID();
SELECT * FROM pelicula;
SELECT * FROM bitacora;

-- **********************************************************************************
/* Aldair Oswaldo Avalos Albino */
-- Trigger bitacora para tabla empleado
-- **********************************************************************************
-- Trigger bitacora para tabla empleado
-- INSERT
DELIMITER //
CREATE TRIGGER bitacora_AI_empleado
AFTER INSERT ON empleado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('INSERT', 'empleado', NEW.id,
            CONCAT(NEW.id, ';', NEW.nombre, ';', NEW.paterno, ';', NEW.materno, ';',NEW.id_categoria, ';', NEW.psw), 
            null,
            USER());
END //
DELIMITER ;

-- UPDATE
DELIMITER //
CREATE TRIGGER bitacora_AU_empleado
AFTER UPDATE ON empleado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('UPDATE', 'empleado', NEW.id, 
			CONCAT(OLD.id, ';', OLD.nombre, ';', OLD.paterno, ';', OLD.materno, ';',OLD.id_categoria, ';', OLD.psw), 
			CONCAT(NEW.id, ';', NEW.nombre, ';', NEW.paterno, ';', NEW.materno, ';',NEW.id_categoria, ';', NEW.psw), 
            USER());
END //
DELIMITER ;

-- DELETE
DELIMITER //
CREATE TRIGGER bitacora_AD_empleado
AFTER DELETE ON empleado
FOR EACH ROW
BEGIN
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('DELETE', 'empleado', OLD.id, 
			CONCAT(OLD.id, ';', OLD.nombre, ';', OLD.paterno, ';', OLD.materno, ';',OLD.id_categoria, ';', OLD.psw), 
            null, 
            USER());
END //
DELIMITER ;

INSERT INTO empleado (nombre, paterno, materno, id_categoria, psw) VALUES
('Aldair', 'Avalos', 'Albino', 5, '192837465'); -- categoria 5 es auxiliar
SELECT * FROM empleado;
SELECT * FROM bitacora;

 -- Ejemplo UPDATE en empleado
UPDATE empleado SET nombre = 'Aldair Oswaldo', id_categoria = 4 WHERE id = LAST_INSERT_ID(); -- la categoria 4 es de supervisor
SELECT * FROM empleado;
SELECT * FROM bitacora;


 -- Ejemplo DELETE en empleado
DELETE FROM empleado WHERE id = LAST_INSERT_ID();
SELECT * FROM empleado;
SELECT * FROM bitacora;

