CREATE DATABASE hospital_monitor
go
use hospital_monitor
go


CREATE TABLE roles (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);
go

CREATE TABLE usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(50) NOT NULL,
    fecha_registro DATETIME DEFAULT GETDATE(),
	id_rol INT,

	CONSTRAINT FK_usuarios_roles
		FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);
go

CREATE TABLE pacientes (
    id_paciente INT PRIMARY KEY,
    dni VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    grupo_sanguineo VARCHAR(5) NOT NULL,
    antecedentes_clinicos VARCHAR(MAX),
	numero_serie VARCHAR(50) UNIQUE NOT NULL,

	CONSTRAINT FK_pacientes_usuarios
		FOREIGN KEY (id_paciente) REFERENCES usuarios(id_usuario)
);
go

CREATE TABLE especialidades (
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
go

CREATE TABLE medicos (
    id_medico INT PRIMARY KEY,
    matricula VARCHAR(50) NOT NULL UNIQUE,
    id_especialidad INT NOT NULL,

    CONSTRAINT FK_medicos_usuarios
        FOREIGN KEY (id_medico) REFERENCES usuarios(id_usuario),

    CONSTRAINT FK_medicos_especialidades
        FOREIGN KEY (id_especialidad) REFERENCES especialidades(id_especialidad)
);
go

CREATE TABLE tipos_medicion (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    unidad VARCHAR(20) NOT NULL
);
go

CREATE TABLE mediciones (
    id_medicion INT IDENTITY(1,1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_tipo INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    fecha_hora DATETIME DEFAULT GETDATE(),

	CONSTRAINT FK_mediciones_pacientes
		FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    
	CONSTRAINT FK_mediciones_tipos_mediciones
		FOREIGN KEY (id_tipo) REFERENCES tipos_medicion(id_tipo)
);
go


CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE
);
go

CREATE TABLE parametros (
    id_parametro INT IDENTITY (1,1) PRIMARY KEY,
    id_categoria INT NOT NULL,        -- Niño, Adolescente/Adulto, Deportista
    id_tipo INT NOT NULL,                  -- FK a tipos_medicion
    valor_min DECIMAL(5,2) NOT NULL,
    valor_max DECIMAL(5,2) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,

	CONSTRAINT FK_parametros_tipos_medicion
		FOREIGN KEY (id_tipo) REFERENCES tipos_medicion(id_tipo),
	
	CONSTRAINT FK_parametros_categorias
		FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
	
	CONSTRAINT CHK_valores 
        CHECK (valor_min <= valor_max)
);
go



INSERT INTO roles (nombre) VALUES ('paciente');
INSERT INTO roles (nombre) VALUES ('medico');
INSERT INTO roles (nombre) VALUES ('admin');
go

INSERT INTO tipos_medicion (nombre, unidad) VALUES ('Oxigeno en sangre', '%');
INSERT INTO tipos_medicion (nombre, unidad) VALUES ('Ritmo cardiaco', 'bpm');
go



INSERT INTO categorias (nombre) VALUES
('Niño'),
('Adolescente/Adulto'),
('Deportista'),
('General');
go
--FRECUENCIA CARDIACA

-- Niño
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (1, 2, 80, 130, 'Rango normal');
go
-- Adolescente/Adulto
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (2, 2, 60, 100, 'Rango normal');
go
-- Deportista (óptimo)
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (3, 2, 40, 59, 'Óptimo');
go
-- Deportista (ligeramente alto)
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (3, 2, 60, 70, 'Aceptable');
go
-- Deportista (alto)
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (3, 2, 71, 80, 'Alto');
go

--OXIGENO EN SANGRE

-- Normal
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (4, 1, 95, 100, 'Normal');
go
-- Bajo
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (4, 1, 92, 94, 'Bajo');
go
-- Alerta
INSERT INTO parametros (id_categoria, id_tipo, valor_min, valor_max, descripcion)
VALUES (4, 1, 0, 91, 'Alerta');
go


-- Pacientes (id_rol = 1)
INSERT INTO usuarios (nombre, apellido, email, contraseña, fecha_registro, id_rol) VALUES
('Juan','Perez','juan1@mail.com','1234',GETDATE(),1),
('Maria','Gomez','maria2@mail.com','1234',GETDATE(),1),
('Lucas','Fernandez','lucas3@mail.com','1234',GETDATE(),1),
('Ana','Martinez','ana4@mail.com','1234',GETDATE(),1),
('Carlos','Lopez','carlos5@mail.com','1234',GETDATE(),1),
('Sofia','Diaz','sofia6@mail.com','1234',GETDATE(),1),
('Mateo','Ruiz','mateo7@mail.com','1234',GETDATE(),1),
('Valentina','Torres','vale8@mail.com','1234',GETDATE(),1),
('Tomas','Romero','tomas9@mail.com','1234',GETDATE(),1),
('Camila','Alvarez','camila10@mail.com','1234',GETDATE(),1),

-- Médicos (id_rol = 2)
('Pedro','Gonzalez','medico1@mail.com','1234',GETDATE(),2),
('Laura','Ramirez','medico2@mail.com','1234',GETDATE(),2);
go

INSERT INTO pacientes (id_paciente, dni, fecha_nacimiento, telefono, grupo_sanguineo, antecedentes_clinicos, numero_serie) VALUES
(1,'40111222','2000-05-12','3511111111','O+','Ninguno','DEV001'),
(2,'45123456','2010-08-22','3511111112','A+','Asma','DEV002'),
(3,'30123456','1985-03-10','3511111113','B+','Ninguno','DEV003'),
(4,'50123456','2015-11-30','3511111114','O-','Ninguno','DEV004'),
(5,'39123456','1998-07-19','3511111115','A-','Hipertensión','DEV005'),
(6,'42123456','2003-01-25','3511111116','B-','Ninguno','DEV006'),
(7,'48123456','2012-06-14','3511111117','O+','Ninguno','DEV007'),
(8,'36123456','1995-09-05','3511111118','AB+','Ninguno','DEV008'),
(9,'41123456','2001-12-01','3511111119','A+','Ninguno','DEV009'),
(10,'32123456','1988-04-18','3511111220','O+','Diabetes','DEV010');
go

INSERT INTO especialidades (nombre) VALUES
('Cardiología'),
('Clínica Médica'),
('Pediatría'),
('Neurología'),
('Traumatología');
go

INSERT INTO medicos (id_medico, matricula, id_especialidad) VALUES 
(11, 'MP12345', 1),
(12, 'MP12344', 1);
go

INSERT INTO mediciones (id_paciente, id_tipo, valor, fecha_hora) VALUES

-- Frecuencia cardíaca
(1,2,72,GETDATE()),    -- normal
(2,2,110,GETDATE()),   -- alto
(3,2,65,GETDATE()),    -- normal
(4,2,120,GETDATE()),   -- alto
(5,2,55,GETDATE()),    -- bajo
(6,2,45,GETDATE()),    -- deportista óptimo
(7,2,68,GETDATE()),    -- deportista aceptable
(8,2,75,GETDATE()),    -- deportista alto
(9,2,95,GETDATE()),    -- normal
(10,2,102,GETDATE()),  -- alto

-- Oxígeno en sangre
(1,1,98,GETDATE()),    -- normal
(2,1,93,GETDATE()),    -- bajo
(3,1,97,GETDATE()),    -- normal
(4,1,91,GETDATE()),    -- alerta
(5,1,96,GETDATE()),    -- normal
(6,1,94,GETDATE()),    -- bajo
(7,1,89,GETDATE()),    -- alerta
(8,1,99,GETDATE()),    -- normal
(9,1,95,GETDATE()),    -- normal
(10,1,92,GETDATE());   -- bajo
go

--select para probar todo
SELECT 
    u.nombre,
    u.apellido,
    c.nombre AS categoria,
    tm.nombre AS tipo_medicion,
    m.valor,
    p.valor_min,
    p.valor_max,
    p.descripcion AS estado,
    m.fecha_hora,
    pa.numero_serie
FROM mediciones m
JOIN pacientes pa 
    ON m.id_paciente = pa.id_paciente
JOIN usuarios u 
    ON pa.id_paciente = u.id_usuario
JOIN tipos_medicion tm 
    ON m.id_tipo = tm.id_tipo
JOIN parametros p 
    ON m.id_tipo = p.id_tipo
    AND m.valor BETWEEN p.valor_min AND p.valor_max
JOIN categorias c 
    ON p.id_categoria = c.id_categoria
ORDER BY m.fecha_hora DESC


--SELECT

--1 muestra todos los tipos de medicion con su unidad
select nombre, unidad
from tipos_medicion

--2 muestra todos los pacientes con su numero de serie
select u.nombre, u.apellido, p.numero_serie
from pacientes p
join usuarios u on p.id_paciente = u.id_usuario

--3 muestra nombre, apellido y si es medico o paciente
select nombre, apellido, 'Paciente' as rol
from usuarios
where id_rol = 1

union

select nombre, apellido, 'Medico' as rol
from usuarios
where id_rol = 2

--4 muestra todas las mediciones con su valor
select
u.nombre,
u.apellido,
tm.nombre as tipo_medicion,
m.valor,
m.fecha_hora
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo

--5 muestra pacientes con sus grupos sanguineos 
select u.nombre, u.apellido, p.grupo_sanguineo
from pacientes p
join usuarios u on p.id_paciente = u.id_usuario

--6 muestra todas las mediciones con su tipo y valores
select
u.nombre,
u.apellido,
tm.nombre as tipo,
m.valor
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo

--7 muestra pacientes que tienen antecedentes clinicos
select u.nombre, u.apellido, p.antecedentes_clinicos
from pacientes p
join usuarios u on p.id_paciente = u.id_usuario
where p.antecedentes_clinicos <> 'Ninguno'

--8 muestra promedio de mediciones por tipo
select tm.nombre, avg(m.valor) as promedio
from mediciones m
join tipos_medicion tm on m.id_tipo = tm.id_tipo
group by tm.nombre

--9 muestra minimo y maximo por tipo de medicion
select tm.nombre, min(m.valor) as minimo, max(m.valor) as maximo
from mediciones m
join tipos_medicion tm on m.id_tipo = tm.id_tipo
group by tm.nombre

--10 muestra cantidad de mediciones por paciente
select
u.nombre,
u.apellido,
count(*) as cantidad
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
group by u.nombre, u.apellido

--11 muestra la ultima medicion registrada de cada paciente
select
u.nombre,
u.apellido,
max(m.fecha_hora) as ultima_medicion
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
group by u.nombre, u.apellido

--12 muestra el promedio de mediciones por paciente y tipo
select
u.nombre,
u.apellido,
tm.nombre as tipo_medicion,
avg(m.valor) as promedio
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo
group by u.nombre, u.apellido, tm.nombre
order by u.nombre, tm.nombre

--13 muestra pacientes con mediciones mayores al promedio de su tipo
select
u.nombre,
u.apellido,
tm.nombre as tipo_medicion,
m.valor
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo
where m.valor > (
select avg(valor)
from mediciones
where id_tipo = m.id_tipo
)


--14 muestra pacientes con al menos una medicion registrada
select distinct
u.nombre,
u.apellido
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario

--15 muestra pacientes con mediciones fuera de los parametros normales
select
u.nombre,
u.apellido,
tm.nombre as tipo_medicion,
m.valor
from mediciones m
join pacientes pa on m.id_paciente = pa.id_paciente
join usuarios u on pa.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo
left join parametros p
on m.id_tipo = p.id_tipo
and m.valor between p.valor_min and p.valor_max
where p.id_parametro is null

--16 muestra promedio de mediciones por grupo sanguineo
select p.grupo_sanguineo, avg(m.valor) as promedio
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
group by p.grupo_sanguineo

--17 muestra cantidad de pacientes por grupo sanguineo
select grupo_sanguineo, count(*) as cantidad
from pacientes
group by grupo_sanguineo

--18 muestra la medicion mas alta registrada por cada paciente y su tipo
select
u.nombre,
u.apellido,
tm.nombre as tipo_medicion,
max(m.valor) as medicion_maxima
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
join tipos_medicion tm on m.id_tipo = tm.id_tipo
group by u.nombre, u.apellido, tm.nombre
order by nombre, medicion_maxima desc

--19 muestra los pacientes cuyo promedio de mediciones es mayor a 80
select
u.nombre,
u.apellido,
avg(m.valor) as promedio
from mediciones m
join pacientes p on m.id_paciente = p.id_paciente
join usuarios u on p.id_paciente = u.id_usuario
group by u.nombre, u.apellido
having avg(m.valor) > 80