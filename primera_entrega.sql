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

-- Crear tabla pelicula
CREATE TABLE pelicula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    duracion INT NOT NULL CHECK (duracion > 0),
    distribuidor VARCHAR(50) NOT NULL,
    clasificacion VARCHAR(10) NOT NULL,
    director VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    descripcion MEDIUMTEXT NOT NULL
);

-- Crear tabla sala
CREATE TABLE sala (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
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

-- Versión usando llave compuesta para Asiento, nota como se tienen que agregar dos columnas a Boleto, id_sala y numero_asiento, para poder implementar la llave foranea compuesta que hace referencia a Asiento.


CREATE TABLE asiento (
	id_sala INT NOT NULL,
    	numero INT NOT NULL,
	estado VARCHAR(10) NOT NULL CHECK (estado IN ('disponible', 'ocupado')) DEFAULT 'disponible',
    PRIMARY KEY (id_sala, numero),
    CONSTRAINT fk_a_id_sala FOREIGN KEY (id_sala) REFERENCES sala(id)
);


-- Crear tabla boleto
CREATE TABLE boleto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_funcion INT NOT NULL,
    id_venta INT NOT NULL,
    CONSTRAINT fk_b_funcion FOREIGN KEY (id_funcion) REFERENCES funcion(id),
    CONSTRAINT fk_b_venta FOREIGN KEY (id_venta) REFERENCES venta(id)
);


-- Tablas Puente
CREATE TABLE venta_snack (	
    id_venta INT NOT NULL,
    id_snack INT NOT NULL,
    PRIMARY KEY (id_venta, id_snack),
    CONSTRAINT fk_vs_venta FOREIGN KEY (id_venta) REFERENCES venta(id) ON DELETE CASCADE,
    CONSTRAINT fk_vs_snack FOREIGN KEY (id_snack) REFERENCES snack(id) ON DELETE CASCADE
);

CREATE TABLE combo_snack (	
    id_combo INT NOT NULL,
    id_snack INT NOT NULL,
    PRIMARY KEY (id_combo, id_snack),
    CONSTRAINT fk_cs_combo FOREIGN KEY (id_combo) REFERENCES combo(id) ON DELETE CASCADE,
    CONSTRAINT fk_cs_snack FOREIGN KEY (id_snack) REFERENCES snack(id) ON DELETE CASCADE
);


-- *********************************************************************
-- DML Statements
-- *********************************************************************
-- Insert sample d-- Insert sample data into socio
INSERT INTO socio (nombre, paterno, materno, fecha_inicio, puntos, passwd) VALUES
('Juan', 'Pérez', 'Gómez', '2023-01-15', 100, 'password123'),
('Ana', 'García', 'Lopez', '2023-02-20', 200, 'password456'),
('Luis', 'Martínez', 'Paredes', '2023-03-05', 150, 'password789'),
('Marta', 'Jiménez', 'Fernández', '2023-04-10', 250, 'password321'),
('Pedro', 'Hernández', 'Sánchez', '2023-05-15', 300, 'password654'),
('Claudia', 'Morales', 'Ramírez', '2023-06-20', 180, 'password987'),
('Jorge', 'Torres', 'Pérez', '2023-07-25', 120, 'password654'),
('Elena', 'González', 'Molina', '2023-08-30', 200, 'password112'),
('Ricardo', 'Álvarez', 'López', '2023-09-10', 220, 'password113'),
('Sofía', 'Reyes', 'Castro', '2023-10-05', 160, 'password114');

-- Insert sample data into categoria_empleado
INSERT INTO categoria_empleado (categoria, sueldo) VALUES
('Cajero', 1500.00),
('Encargado', 2500.00),
('Gerente', 3500.00),
('Supervisor', 3000.00),
('Auxiliar', 1200.00);

-- Insert sample data into empleado
INSERT INTO empleado (nombre, paterno, materno, id_categoria, psw) VALUES
('Carlos', 'Fernández', 'Hernández', 1, 'psw7891223'),
('María', 'Rodríguez', 'Sánchez', 2, 'psw101112'),
('Ana', 'Martínez', 'Gómez', 3, 'psw131415'),
('Pedro', 'González', 'Ríos', 4, 'psw161718'),
('Lucía', 'Pérez', 'Fernández', 5, 'psw192021'),
('Gabriel', 'Soto', 'López', 1, 'psw222324'),
('Laura', 'Ramírez', 'Hernández', 2, 'psw252627'),
('Miguel', 'Jiménez', 'Rodríguez', 3, 'psw282930'),
('Isabel', 'Álvarez', 'García', 4, 'psw313233'),
('Andrés', 'Cano', 'Martínez', 5, 'psw343536');

-- Insert sample data into pelicula
INSERT INTO Pelicula (titulo, distribuidor, duracion, clasificacion, director, pais, descripcion) VALUES 
('Inception', 'Warner Bros', 148, 'PG-13', 'Christopher Nolan', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Matrix', 'Warner Bros', 136, 'R', 'Lana Wachowski, Lilly Wachowski', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Interstellar', 'Paramount Pictures', 169, 'PG-13', 'Christopher Nolan', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Dark Knight', 'Warner Bros', 152, 'PG-13', 'Christopher Nolan', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Pulp Fiction', 'Miramax', 154, 'R', 'Quentin Tarantino', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Fight Club', '20th Century Fox', 139, 'R', 'David Fincher', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Forrest Gump', 'Paramount Pictures', 142, 'PG-13', 'Robert Zemeckis', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Shawshank Redemption', 'Columbia Pictures', 142, 'R', 'Frank Darabont', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Godfather', 'Paramount Pictures', 175, 'R', 'Francis Ford Coppola', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Godfather Part II', 'Paramount Pictures', 202, 'R', 'Francis Ford Coppola', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Lord of the Rings: The Fellowship of the Ring', 'New Line Cinema', 178, 'PG-13', 'Peter Jackson', 'New Zealand', 'Hola Mundo Descripcion Pelicula'),
('The Lord of the Rings: The Two Towers', 'New Line Cinema', 179, 'PG-13', 'Peter Jackson', 'New Zealand', 'Hola Mundo Descripcion Pelicula'),
('The Lord of the Rings: The Return of the King', 'New Line Cinema', 201, 'PG-13', 'Peter Jackson', 'New Zealand', 'Hola Mundo Descripcion Pelicula'),
('Gladiator', 'DreamWorks', 155, 'R', 'Ridley Scott', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Departed', 'Warner Bros', 151, 'R', 'Martin Scorsese', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Silence of the Lambs', 'Orion Pictures', 118, 'R', 'Jonathan Demme', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Usual Suspects', 'Bryan Singer', 106, 'R', 'Bryan Singer', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Se7en', 'New Line Cinema', 127, 'R', 'David Fincher', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Lion King', 'Disney', 88, 'G', 'Roger Allers, Rob Minkoff', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Toy Story', 'Pixar', 81, 'G', 'John Lasseter', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Finding Nemo', 'Pixar', 100, 'G', 'Andrew Stanton', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Up', 'Pixar', 96, 'PG', 'Pete Docter', 'USA', 'Hola Mundo Descripcion Pelicula'),
('WALL-E', 'Pixar', 98, 'G', 'Andrew Stanton', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Ratatouille', 'Pixar', 111, 'G', 'Brad Bird', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Incredibles', 'Pixar', 115, 'PG', 'Brad Bird', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Monsters, Inc.', 'Pixar', 92, 'G', 'Pete Docter', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Brave', 'Pixar', 93, 'PG', 'Mark Andrews, Brenda Chapman', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Coco', 'Pixar', 105, 'PG', 'Lee Unkrich', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Inside Out', 'Pixar', 95, 'PG', 'Pete Docter', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: A New Hope', 'Lucasfilm', 121, 'PG', 'George Lucas', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: The Empire Strikes Back', 'Lucasfilm', 124, 'PG', 'Irvin Kershner', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: Return of the Jedi', 'Lucasfilm', 131, 'PG', 'Richard Marquand', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: The Phantom Menace', 'Lucasfilm', 136, 'PG', 'George Lucas', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: Attack of the Clones', 'Lucasfilm', 142, 'PG', 'George Lucas', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: Revenge of the Sith', 'Lucasfilm', 140, 'PG-13', 'George Lucas', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: The Force Awakens', 'Lucasfilm', 138, 'PG-13', 'J.J. Abrams', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: The Last Jedi', 'Lucasfilm', 152, 'PG-13', 'Rian Johnson', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Star Wars: The Rise of Skywalker', 'Lucasfilm', 142, 'PG-13', 'J.J. Abrams', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Jurassic Park', 'Universal Pictures', 127, 'PG-13', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Jurassic World', 'Universal Pictures', 124, 'PG-13', 'Colin Trevorrow', 'USA', 'Hola Mundo Descripcion Pelicula'),
('E.T. the Extra-Terrestrial', 'Universal Pictures', 115, 'PG', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Back to the Future', 'Universal Pictures', 116, 'PG', 'Robert Zemeckis', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Indiana Jones and the Raiders of the Lost Ark', 'Paramount Pictures', 115, 'PG', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Indiana Jones and the Last Crusade', 'Paramount Pictures', 127, 'PG-13', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Raiders of the Lost Ark', 'Paramount Pictures', 115, 'PG', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Jaws', 'Universal Pictures', 124, 'PG', 'Steven Spielberg', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Casablanca', 'Warner Bros', 102, 'PG', 'Michael Curtiz', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Big Lebowski', 'Universal Pictures', 117, 'R', 'Joel Coen, Ethan Coen', 'USA', 'Hola Mundo Descripcion Pelicula'),
('Goodfellas', 'Warner Bros', 146, 'R', 'Martin Scorsese', 'USA', 'Hola Mundo Descripcion Pelicula'),
('The Graduate', 'United Artists', 106, 'PG', 'Mike Nichols', 'USA', 'Hola Mundo Descripcion Pelicula');


-- Insert sample data into sala
INSERT INTO sala (categoria, capacidad, estado) VALUES
('VIP', 50, 'disponible'),
('Regular', 100, 'disponible'),
('Standard', 75, 'ocupada'),
('Deluxe', 40, 'disponible'),
('Economy', 120, 'mantenimiento'),
('Premium', 60, 'disponible'),
('Luxury', 30, 'ocupada'),
('Classic', 80, 'disponible'),
('Executive', 45, 'mantenimiento'),
('Comfort', 90, 'disponible');

-- Insert sample data into funcion
INSERT INTO funcion (id_pelicula, fecha, horario, id_sala, idioma) VALUES
(1, '2024-09-16', '18:00:00', 1, 'Español'),
(2, '2024-09-14', '20:30:00', 2, 'Español'),
(3, '2024-09-15', '21:00:00', 3, 'Inglés'),
(4, '2024-09-15', '19:00:00', 4, 'Español'),
(5, '2024-09-17', '17:00:00', 5, 'Francés'),
(6, '2024-09-18', '22:00:00', 6, 'Español'),
(7, '2024-09-19', '18:30:00', 7, 'Inglés'),
(8, '2024-09-20', '20:00:00', 8, 'Español'),
(9, '2024-09-21', '21:30:00', 9, 'Inglés'),
(10, '2024-09-22', '23:00:00', 10, 'Español');

-- Insert sample data into snack
INSERT INTO snack (nombre, precio, tamanio) VALUES
('Palomitas', 5.00, 'chico'),
('Refresco', 3.00,'mediano'),
('Nachos', 6.00, null),
('Dulces', 4.00, null),
('Hot Dog', 7.00, null),
('Cerveza', 5.50, null),
('Agua', 2.00, null),
('Chocolates', 4.50, null),
('Galletas', 3.50, null),
('Pretzels', 4.00, null);

-- Insert sample data into combo
INSERT INTO combo (nombre, precio) VALUES
('Combo Familiar', 12.00),
('Combo Individual', 6.00),
('Combo Grande', 15.00),
('Combo Pequeño', 8.00),
('Combo Premium', 18.00),
('Combo Básico', 10.00),
('Combo Deluxe', 20.00),
('Combo Especial', 14.00),
('Combo Standard', 7.00),
('Combo Extra', 16.00);


-- Insert sample data into venta
INSERT INTO venta (id_empleado, id_socio, metodo_pago, area, total, creada_en) VALUES
(1, 1, 'efectivo', 'taquilla', 230, '2024-09-17 20:30:15'),
(2, 2, 'credito', 'dulceria', 120, '2024-09-16 21:30:15'),
(3, 3, 'efectivo', 'taquilla', 235, '2024-09-18 19:30:15'),
(4, 4, 'credito', 'dulceria', 230, '2024-09-17 18:30:15'),
(5, 5, 'efectivo', 'taquilla', 120, '2024-09-18 18:31:12'),
(6, 6, 'credito', 'dulceria', 90, '2024-09-17 2:30:15'),
(7, 7, 'efectivo', 'taquilla', 70, '2024-09-17 20:30:15'),
(8, 8, 'credito', 'dulceria', 230, '2024-09-16 20:30:15'),
(9, 9, 'efectivo', 'taquilla', 270, '2024-09-16 21:20:15'),
(10, 10, 'credito', 'dulceria', 260, '2024-09-17 20:20:15');

-- Insert sample data into asiento
INSERT INTO asiento (id_sala, numero, estado) VALUES
(1, 1, 'disponible'), (1, 2, 'ocupado'), (1, 3, 'disponible'), (1, 4, 'ocupado'), (1, 5, 'disponible'), (1, 6, 'disponible'), (1, 7, 'ocupado'), 
(1,8,'disponible'), (1, 9, 'disponible'), (1, 10, 'disponible'),(2,1,'disponible'),(2,2,'disponible'), (2, 3, 'ocupado'), (2, 4, 'disponible'), (2, 5, 'disponible'), 
(2, 6, 'ocupado'), (2, 7, 'disponible'), (2, 8, 'disponible'), (2, 9, 'disponible'), (2, 10, 'ocupado'),(3, 1, 'ocupado'), (3, 2, 'disponible'), (3, 3, 'disponible'), 
(3, 4, 'ocupado'), (3, 5, 'disponible'), (3, 6, 'disponible'), (3, 7, 'disponible'), (3, 8, 'ocupado'), (3, 9, 'disponible'), (3, 10, 'disponible'),(4, 1, 'disponible'), 
(4, 2, 'ocupado'), (4, 3, 'disponible'), (4, 4, 'disponible'), (4, 5, 'ocupado'), (4, 6, 'disponible'), (4, 7, 'disponible'), (4, 8, 'disponible'), (4, 9, 'ocupado'), 
(4, 10, 'disponible'),(5, 1, 'disponible'), (5, 2, 'disponible'), (5, 3, 'ocupado'), (5, 4, 'disponible'), (5, 5, 'disponible'), (5, 6, 'disponible'), (5, 7, 'ocupado'), 
(5, 8, 'disponible'), (5, 9, 'disponible'), (5, 10, 'disponible');



-- Insert sample data into boleto
INSERT INTO boleto (id_funcion, id_venta) VALUES
(1, 1), (1, 1), (1, 1), (1, 1), (1, 1),
(1, 1), (1, 1), (1, 1), (1, 1), (1, 1),
(2, 2), (2, 2), (2, 2), (2, 2), (2, 2),
(2, 2), (2, 2), (2, 2), (2, 2), (2, 2),
(3, 3), (3, 3), (3, 3), (3, 3), (3, 3),
(3, 3), (3, 3), (3, 3), (3, 3), (3, 3),
(4, 4), (4, 4), (4, 4), (4, 4), (4, 4);

-- Insert sample data into venta_snack
INSERT INTO venta_snack (id_venta, id_snack) VALUES
(1, 1),(1, 2),
(2, 3),(2, 4),
(3, 5),(3, 6),
(4, 7),(4, 8),
(5, 9),(5, 10),
(6, 1),(6, 3),
(7, 2),(7, 4),
(8, 5),(8, 6),
(9, 7),(9, 8),
(10, 9);

-- Insert sample data into combo_snack
INSERT INTO combo_snack (id_combo, id_snack) VALUES
(1, 1),(1, 2),
(2, 3),(2, 4),
(3, 5),(3, 6),
(4, 7),(4, 8),
(5, 9),(5, 10),
(6, 1),(6, 3),
(7, 2),(7, 4),
(8, 5),(8, 6),
(9, 7),(9, 8),
(10, 9);
