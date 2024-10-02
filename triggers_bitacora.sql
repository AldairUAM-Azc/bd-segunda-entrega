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
