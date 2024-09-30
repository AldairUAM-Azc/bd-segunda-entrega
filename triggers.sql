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

    IF total_funciones > 15 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se pueden programar más de 15 funciones para cada película.';
    END IF;
END;

DELIMITER ;
