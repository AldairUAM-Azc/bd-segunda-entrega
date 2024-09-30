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
    nombre VARCHAR(45),
    pais VARCHAR(45)
);


-- Crear tabla pelicula
CREATE TABLE pelicula (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    duracion INT NOT NULL CHECK (duracion > 0),
    distribuidor INT NOT NULL,
    clasificacion VARCHAR(10) NOT NULL CHECK (clasificacion IN ('R','PG-13','PG')),
    director INT NOT NULL,
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
    capacidad INT NOT NULL CHECK (capacidad > 0 AND capacidad <= 50),
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

-- Insert de Director
INSERT INTO director (nombre, apellido, nacionalidad) VALUES
('Steven', 'Spielberg', 'Estados Unidos'),
('Christopher', 'Nolan', 'Reino Unido'),
('Quentin', 'Tarantino', 'Estados Unidos'),
('Martin', 'Scorsese', 'Estados Unidos'),
('Ridley', 'Scott', 'Reino Unido'),
('Alfonso', 'Cuarón', 'México'),
('Guillermo', 'del Toro', 'México'),
('Alejandro', 'González Iñárritu', 'México'),
('Pedro', 'Almodóvar', 'España'),
('Wes', 'Anderson', 'Estados Unidos'),
('Stanley', 'Kubrick', 'Estados Unidos'),
('Francis Ford', 'Coppola', 'Estados Unidos'),
('Tim', 'Burton', 'Estados Unidos'),
('David', 'Fincher', 'Estados Unidos'),
('James', 'Cameron', 'Canadá'),
('Sofia', 'Coppola', 'Estados Unidos'),
('Paul', 'Thomas Anderson', 'Estados Unidos'),
('Darren', 'Aronofsky', 'Estados Unidos'),
('Spike', 'Lee', 'Estados Unidos'),
('George', 'Lucas', 'Estados Unidos'),
('Denis', 'Villeneuve', 'Canadá'),
('Jean-Pierre', 'Jeunet', 'Francia'),
('Greta', 'Gerwig', 'Estados Unidos'),
('Bong', 'Joon-ho', 'Corea del Sur'),
('Park', 'Chan-wook', 'Corea del Sur'),
('Ang', 'Lee', 'Taiwán'),
('Akira', 'Kurosawa', 'Japón'),
('Hayao', 'Miyazaki', 'Japón'),
('Yorgos', 'Lanthimos', 'Grecia'),
('Ken', 'Loach', 'Reino Unido'),
('Lars', 'von Trier', 'Dinamarca'),
('Michel', 'Gondry', 'Francia'),
('Luc', 'Besson', 'Francia'),
('Roman', 'Polanski', 'Polonia'),
('Fernando', 'Meirelles', 'Brasil'),
('Walter', 'Salles', 'Brasil'),
('Hirokazu', 'Koreeda', 'Japón'),
('Taika', 'Waititi', 'Nueva Zelanda'),
('Patty', 'Jenkins', 'Estados Unidos'),
('Damien', 'Chazelle', 'Estados Unidos'),
('Jane', 'Campion', 'Nueva Zelanda'),
('Nora', 'Ephron', 'Estados Unidos'),
('Patrice', 'Leconte', 'Francia'),
('Claire', 'Denis', 'Francia'),
('Mira', 'Nair', 'India'),
('Milos', 'Forman', 'República Checa'),
('Pedro', 'Costa', 'Portugal'),
('Ari', 'Aster', 'Estados Unidos'),
('Robert', 'Eggers', 'Estados Unidos'),
('Jony', 'Hdez', 'México');

-- INSERT de distribuidores
INSERT INTO distribuidor (nombre, pais) VALUES
('Warner Bros.', 'Estados Unidos'),
('Universal Pictures', 'Estados Unidos'),
('Paramount Pictures', 'Estados Unidos'),
('Sony Pictures', 'Estados Unidos'),
('20th Century Studios', 'Estados Unidos'),
('Focus Features', 'Estados Unidos'),
('Miramax Films', 'Estados Unidos'),
('Lionsgate Films', 'Estados Unidos'),
('A24', 'Estados Unidos'),
('Fox Searchlight', 'Estados Unidos'),
('Walt Disney Studios', 'Estados Unidos'),
('Netflix', 'Estados Unidos'),
('Amazon Studios', 'Estados Unidos'),
('New Line Cinema', 'Estados Unidos'),
('Columbia Pictures', 'Estados Unidos'),
('BBC Films', 'Reino Unido'),
('Working Title Films', 'Reino Unido'),
('Film4 Productions', 'Reino Unido'),
('Eon Productions', 'Reino Unido'),
('Pathé', 'Francia'),
('Gaumont Film Company', 'Francia'),
('StudioCanal', 'Francia'),
('EuropaCorp', 'Francia'),
('Wild Bunch', 'Francia'),
('Toho', 'Japón'),
('Shochiku', 'Japón'),
('Ghibli', 'Japón'),
('CJ Entertainment', 'Corea del Sur'),
('Showbox', 'Corea del Sur'),
('Magnet Releasing', 'Estados Unidos'),
('Dimension Films', 'Estados Unidos'),
('Sony Pictures Classics', 'Estados Unidos'),
('Canal+', 'Francia'),
('SBS Productions', 'Francia'),
('Cinéart', 'Bélgica'),
('O2 Filmes', 'Brasil'),
('Globo Filmes', 'Brasil'),
('Participant Media', 'Estados Unidos'),
('PolyGram Filmed Entertainment', 'Reino Unido'),
('IFC Films', 'Estados Unidos'),
('Aardman Animations', 'Reino Unido'),
('Madman Entertainment', 'Australia'),
('New Zealand Film Commission', 'Nueva Zelanda'),
('Huayi Brothers', 'China'),
('The Match Factory', 'Alemania'),
('FilmNation Entertainment', 'Estados Unidos'),
('TriStar Pictures', 'Estados Unidos'),
('Castle Rock Entertainment', 'Estados Unidos'),
('Annapurna Pictures', 'Estados Unidos'),
('Nickelodeon', 'Estados Unidos');

-- Insert sample data into pelicula

INSERT INTO pelicula (titulo, duracion, distribuidor, clasificacion, director, descripcion) VALUES
('Jurassic Park', 127, 1, 'PG-13', 1, 'Una película sobre un parque temático donde los dinosaurios cobran vida.'),
('Inception', 148, 2, 'PG-13', 2, 'Un ladrón roba secretos de los sueños y lucha por redimirse.'),
('Pulp Fiction', 154, 3, 'R', 3, 'Vidas interconectadas a través de crímenes y momentos inesperados.'),
('Goodfellas', 146, 4, 'R', 4, 'La vida de un gánster a través de varias décadas en Nueva York.'),
('Gladiator', 155, 5, 'R', 5, 'Un general romano busca venganza tras la traición del emperador.'),
('Gravity', 91, 6, 'PG-13', 6, 'Dos astronautas quedan atrapados en el espacio tras un accidente.'),
('The Shape of Water', 123, 7, 'R', 7, 'Una trabajadora se enamora de una criatura acuática capturada.'),
('The Revenant', 156, 8, 'R', 8, 'Un hombre lucha por sobrevivir tras ser atacado por un oso.'),
('Volver', 121, 9, 'R', 9, 'Un relato sobre mujeres fuertes enfrentando el pasado y el presente.'),
('The Grand Budapest Hotel', 99, 10, 'R', 10, 'La historia de un legendario conserje en un hotel de lujo.'),
('A Clockwork Orange', 136, 11, 'R', 11, 'Un joven delincuente es sometido a experimentos de rehabilitación.'),
('The Godfather', 175, 12, 'R', 12, 'La saga de una familia de la mafia en Nueva York.'),
('Beetlejuice', 92, 13, 'PG', 13, 'Una pareja fallecida trata de ahuyentar a los nuevos residentes de su casa.'),
('Fight Club', 139, 14, 'R', 14, 'Un hombre forma un club de lucha clandestino como escape de su vida.'),
('Titanic', 195, 15, 'PG-13', 15, 'Una historia de amor a bordo del famoso barco Titanic.'),
('Lost in Translation', 102, 16, 'R', 16, 'Un actor y una joven forjan una conexión inesperada en Tokio.'),
('There Will Be Blood', 158, 17, 'R', 17, 'La vida de un magnate del petróleo obsesionado con el poder.'),
('Black Swan', 108, 18, 'R', 18, 'Una bailarina lucha con la presión mientras se prepara para su papel soñado.'),
('Do the Right Thing', 120, 19, 'R', 19, 'Un día de tensión racial en un vecindario de Brooklyn.'),
('Star Wars', 121, 20, 'PG', 20, 'Una lucha épica entre el bien y el mal en una galaxia muy lejana.'),
('Blade Runner 2049', 164, 21, 'R', 21, 'Un replicante descubre un secreto que podría cambiar el futuro.'),
('Amélie', 122, 22, 'R', 22, 'Una joven busca mejorar la vida de los que la rodean en París.'),
('Lady Bird', 94, 23, 'R', 23, 'Una joven navega por los retos de la adolescencia en Sacramento.'),
('Parasite', 132, 24, 'R', 24, 'Una familia pobre se infiltra en la vida de una familia rica.'),
('Oldboy', 120, 25, 'R', 25, 'Un hombre busca venganza tras ser encarcelado sin explicación durante 15 años.'),
('Crouching Tiger, Hidden Dragon', 120, 26, 'PG-13', 26, 'Guerreros expertos buscan recuperar una espada robada en la antigua China.'),
('Seven Samurai', 207, 27, 'PG', 27, 'Un grupo de samuráis defiende una aldea de bandidos.'),
('Spirited Away', 125, 28, 'PG', 28, 'Una niña queda atrapada en un misterioso mundo de espíritus.'),
('The Lobster', 119, 29, 'R', 29, 'En una sociedad distópica, los solteros son convertidos en animales si no encuentran pareja.'),
('I, Daniel Blake', 100, 30, 'R', 30, 'Un carpintero lucha contra el sistema de seguridad social del Reino Unido.'),
('Melancholia', 135, 31, 'R', 31, 'Dos hermanas enfrentan la inminente colisión de un planeta con la Tierra.'),
('Eternal Sunshine of the Spotless Mind', 108, 32, 'R', 32, 'Un hombre intenta borrar los recuerdos de su exnovia de su mente.'),
('The Fifth Element', 126, 33, 'PG-13', 33, 'Un taxista en el futuro se encuentra con el elemento clave para salvar a la humanidad.'),
('The Pianist', 150, 34, 'R', 34, 'Un pianista judío sobrevive a la ocupación nazi en Varsovia.'),
('City of God', 130, 35, 'R', 35, 'La historia de dos jóvenes que crecen en una favela de Río de Janeiro.'),
('The Motorcycle Diaries', 126, 36, 'R', 36, 'Un joven Ernesto "Che" Guevara viaja por Sudamérica y se enfrenta a las injusticias sociales.'),
('Shoplifters', 121, 37, 'R', 37, 'Una familia pobre sobrevive cometiendo pequeños robos en Tokio.'),
('Jojo Rabbit', 108, 38, 'PG-13', 38, 'Un niño nazi descubre que su madre está escondiendo a una niña judía en su casa.'),
('Wonder Woman', 141, 39, 'PG-13', 39, 'La princesa amazona Diana se convierte en la heroína conocida como Wonder Woman.'),
('La La Land', 128, 40, 'PG-13', 40, 'Una historia de amor entre una aspirante a actriz y un músico en Los Ángeles.'),
('The Power of the Dog', 126, 41, 'R', 41, 'Dos hermanos enfrentan tensiones familiares en el oeste americano.'),
('Julie & Julia', 123, 42, 'PG-13', 42, 'Una joven decide cocinar todas las recetas de Julia Child en un año.'),
('The Girl on the Bridge', 120, 43, 'R', 43, 'Una mujer joven es rescatada de una vida problemática por un lanzador de cuchillos.'),
('Beau Travail', 93, 44, 'R', 44, 'Un exoficial de la Legión Extranjera francesa reflexiona sobre su vida mientras patrulla en África.'),
('Monsoon Wedding', 114, 45, 'R', 45, 'Una boda en Nueva Delhi revela las tensiones familiares y secretos ocultos.'),
('One Flew Over the Cuckoo\'s Nest', 133, 46, 'R', 46, 'Un hombre rebelde lidera una revuelta en una institución mental.'),
('Vitalina Varela', 124, 47, 'R', 47, 'Una mujer viaja a Portugal después de la muerte de su esposo para descubrir su vida secreta.'),
('Hereditary', 127, 48, 'R', 48, 'Una familia descubre oscuros secretos tras la muerte de su abuela.'),
('The Lighthouse', 110, 49, 'R', 49, 'Dos fareros en una isla remota luchan con la locura y los secretos ocultos.'),
('Avatar', 162, 50, 'PG-13', 15, 'Un marine parapléjico se infiltra en una raza alienígena en Pandora.');



-- Insert sample data into sala
INSERT INTO sala (categoria, capacidad, estado) VALUES
('VIP', 50, 'disponible'),
('Standard', 40, 'ocupada'),
('Premium', 45, 'disponible'),
('VIP', 30, 'mantenimiento'),
('Standard', 25, 'ocupada'),
('Premium', 50, 'disponible'),
('Standard', 35, 'disponible'),
('VIP', 40, 'ocupada'),
('Premium', 30, 'mantenimiento'),
('Standard', 50, 'disponible');


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
