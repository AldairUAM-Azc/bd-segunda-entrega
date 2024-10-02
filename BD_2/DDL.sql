-- *********************************************************************
-- DDL Statements
-- *********************************************************************
DROP DATABASE IF EXISTS CineTubi;
CREATE DATABASE IF NOT EXISTS CineTubi;
USE CineTubi;

-- Crear tabla Socio
CREATE TABLE socio (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  paterno VARCHAR(50) NOT NULL,
  materno VARCHAR(50) NOT NULL,
  fecha_inicio DATE NOT NULL,
  puntos INT NOT NULL DEFAULT 0,
  passwd VARCHAR(255) NOT NULL
);

-- Crear tabla categoria_empleado
CREATE TABLE categoria_empleado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL,
    sueldo DECIMAL(10, 2) NOT NULL CHECK (sueldo > 0)
);

-- Crear tabla empleado
CREATE TABLE empleado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    paterno VARCHAR(50) NOT NULL,
    materno VARCHAR(50) NOT NULL,
    id_categoria INT NOT NULL,
    psw VARCHAR(255) NOT NULL,
    CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) REFERENCES categoria_empleado(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Crear tabla director

CREATE TABLE director (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45),
    apellido VARCHAR(45),
    nacionalidad VARCHAR(45)
);
-- Crear tabla distribuidor

CREATE TABLE distribuidor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) UNIQUE,
    pais VARCHAR(45)
);


-- Crear tabla pelicula
CREATE TABLE pelicula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    duracion INT NOT NULL CHECK (duracion > 0),
    distribuidor INT,
    clasificacion VARCHAR(10) NOT NULL CHECK (clasificacion IN ('R','PG-13','PG')),
    director INT,
    descripcion MEDIUMTEXT NOT NULL,
    CONSTRAINT fk_director FOREIGN KEY (director) REFERENCES director(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_distribuidor FOREIGN KEY (distribuidor) REFERENCES distribuidor(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Crear tabla sala
CREATE TABLE sala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL CHECK (categoria IN ('VIP','Standard','Premium')),
    capacidad INT NOT NULL CHECK (capacidad > 0 AND capacidad <= 30),
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('disponible', 'ocupada', 'mantenimiento'))
);

-- Crear tabla función
CREATE TABLE funcion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pelicula INT NOT NULL,
    fecha DATE,
    horario TIME NOT NULL,
    id_sala INT NOT NULL,
    idioma VARCHAR(30) NOT NULL,
    CONSTRAINT fk_pelicula FOREIGN KEY (id_pelicula) REFERENCES pelicula(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_sala FOREIGN KEY (id_sala) REFERENCES sala(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Crear tabla snack
CREATE TABLE snack (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    tamanio VARCHAR(10) NULL CHECK(tamanio IN ('chico', 'mediano','grande'))
);

-- Crear tabla venta
CREATE TABLE venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_socio INT,
    total DECIMAL NOT NULL,
    creada_en DATETIME NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('efectivo', 'credito')),
    area VARCHAR(30) NOT NULL CHECK (area IN ('taquilla', 'dulceria')),
    CONSTRAINT fk_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_socio FOREIGN KEY (id_socio) REFERENCES socio(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Crear tabla combo
CREATE TABLE combo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    precio DECIMAL NOT NULL CHECK (precio > 0)
);

-- Crear tabla boleto
CREATE TABLE boleto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_funcion INT NOT NULL,
    id_venta INT NOT NULL,
    num_boleto INT NOT NULL,
    CONSTRAINT fk_b_funcion FOREIGN KEY (id_funcion) REFERENCES funcion(id),
    CONSTRAINT fk_b_venta FOREIGN KEY (id_venta) REFERENCES venta(id)
);

-- Tablas Puente
CREATE TABLE venta_snack (	
    id_venta INT NOT NULL,
    id_snack INT NOT NULL,
    cantidad INT NOT NULL DEFAULT (1),
    PRIMARY KEY (id_venta, id_snack),
    CONSTRAINT fk_vs_venta FOREIGN KEY (id_venta) REFERENCES venta(id) ON DELETE CASCADE,
    CONSTRAINT fk_vs_snack FOREIGN KEY (id_snack) REFERENCES snack(id) ON DELETE CASCADE
);

CREATE TABLE venta_combo (	
    id_venta INT NOT NULL,
    id_combo INT NOT NULL,
    cantidad INT NOT NULL DEFAULT (1),
    PRIMARY KEY (id_venta, id_combo),
    CONSTRAINT fk_vc_venta FOREIGN KEY (id_venta) REFERENCES venta(id) ON DELETE CASCADE,
    CONSTRAINT fk_vc_combo FOREIGN KEY (id_combo) REFERENCES combo(id) ON DELETE CASCADE
);

CREATE TABLE combo_snack (	
    id_combo INT NOT NULL,
    id_snack INT NOT NULL,
    unidades INT NOT NULL,
    PRIMARY KEY (id_combo, id_snack),
    CONSTRAINT fk_cs_combo FOREIGN KEY (id_combo) REFERENCES combo(id) ON DELETE CASCADE,
    CONSTRAINT fk_cs_snack FOREIGN KEY (id_snack) REFERENCES snack(id) ON DELETE CASCADE
);
