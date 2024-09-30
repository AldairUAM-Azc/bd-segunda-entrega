/*Bitabora*/
CREATE TABLE bitacora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_operacion VARCHAR(20) NOT NULL,
    tabla_afectada VARCHAR(50) NOT NULL,
    numero_registro INT NOT NULL,
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

/*José Vicente López López*/
-- Trigger Agregar Venta
DELIMITER //
CREATE TRIGGER insertar_venta
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    -- Registrar la operación en la tabla de bitácora para la venta
    INSERT INTO bitacora (tipo_operacion, tabla_afectada, numero_registro, valores_anteriores, valores_nuevos, usuario_aplicacion)
    VALUES ('INSERT', 'venta', NEW.id, '',
            CONCAT('ID Empleado: ', NEW.id_empleado, '; ID Socio: ', NEW.id_socio, '; Total: ', NEW.total), 
            USER());

END //
DELIMITER ;

/* -- Si guarda
INSERT INTO venta (id_empleado, id_socio, metodo_pago, area, total, creada_en) VALUES
(1, 5, 'credito', 'taquilla', 230, '2024-09-30 20:30:15');

SELECT * FROM bitacora;
*/