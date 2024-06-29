CREATE DATABASE IF NOT EXISTS Hospital;
USE Hospital;

CREATE TABLE Medico (
medico_id INT UNSIGNED AUTO_INCREMENT,
nombre VARCHAR(80) NOT NULL,
apellido VARCHAR(80) NOT NULL,
especialidad VARCHAR(80) NOT NULL,
CONSTRAINT pk_medico PRIMARY KEY (medico_id)
);


CREATE TABLE Disponibilidad (
disponibilidad_id INT UNSIGNED AUTO_INCREMENT,
dia ENUM('lunes','martes','miercoles','jueves','viernes','sabado','domingo') NOT NULL,
medico_id INT UNSIGNED,
CONSTRAINT pk_disponibilidad PRIMARY KEY(disponibilidad_id),-- Aunque no creo usarlo 
CONSTRAINT fk_medico_id FOREIGN KEY(medico_id)REFERENCES Medico (medico_id)
);

CREATE TABLE Paciente (
paciente_id INT UNSIGNED AUTO_INCREMENT,
nombre VARCHAR(80) NOT NULL,
apellido VARCHAR(80) NOT NULL,
edad INT UNSIGNED NOT NULL,
telefono varchar(80) NOT NULL,
contacto_emergencia varchar(80) ,
CONSTRAINT pk_paciente PRIMARY KEY (paciente_id)
);

CREATE TABLE Cita (
cita_id INT UNSIGNED AUTO_INCREMENT,
medico_id INT UNSIGNED NOT NULL,
paciente_id INT UNSIGNED NOT NULL,
estado ENUM('Programado','Cancelado') DEFAULT 'Programado',
fecha DATE NOT NULL,
comentario VARCHAR(200), -- aca podriamos traer las condiciones "traer ropa holgada o venir en ayuno" por ejemplo, preguntar 

CONSTRAINT pk_cita PRIMARY KEY(cita_id),
CONSTRAINT fkc_medico_id FOREIGN KEY(medico_id) REFERENCES Medico(medico_id),
CONSTRAINT fk_paciente_id FOREIGN KEY(paciente_id) REFERENCES Paciente(paciente_id)
);

-- medicos
	-- crear un medico
delimiter //
create procedure crearMedico(in pNombre VARCHAR(80), pApellido VARCHAR(80), pEspecialidad VARCHAR(80))
begin
	insert into medico(nombre,apellido,especialidad)
    values (pNombre,pApellido,pEspecialidad);
end//
delimiter ;
call crearMedico('sergio','perez','pediatra');
	-- actualizar un valor del medcio
delimiter //
create procedure modificarMedico(in pID int, pValor VARCHAR(80), pNuevoValor VARCHAR(80))
begin 
	if pValor = 'nombre' then 
	update medico
    set nombre = pNuevoValor
    where medico_id = pID;
    
    elseif pValor = 'apellido' then 
	update medico
    set apellido = pNuevoValor
    where medico_id = pID;
    
    elseif pValor = 'especialidad' then 
	update medico
    set especialidad = pNuevoValor
    where medico_id = pID;
    end if;
end//
delimiter ;

call modificarMedico(1,'especialidad','traumatologo');
	
    -- eliminar un medico
delimiter //
create procedure eliminarMedico(in pId int)
begin 
	set foreign_key_checks = 0;
	delete from Medico 
    where medico_id = pId;
    set foreign_key_checks = 1;
    
end //
delimiter ;

call eliminarMedico(2);
call mostrarMedicos();




	-- leer todos los medicos
delimiter // 
create procedure mostrarMedicos()
begin
select * from Medico;
end//
delimiter ;
call mostrarMedicos();

insert into Medico(nombre,apellido,especialidad) values ('didier','shnr','cardiologia');
insert into Disponibilidad(dia,medico_id) values('lunes',1);

select * from Medico;
select m.nombre, m.apellido
from Medico m 
inner join Disponibilidad d
ON m.medico_id = d.medico_id
where dia = 'lunes'
order by m.nombre;

-- PROCEDIMIENTOS ALMCENADO DE OPERACIONES CRUD
DELIMITER 

-- CREAR MEDICO!
CREATE PROCEDURE CrearMedico (
    IN p_nombre VARCHAR(80),
    IN p_apellido VARCHAR(80),
    IN p_especialidad VARCHAR(80)
)
BEGIN
    INSERT INTO Medico (nombre, apellido, especialidad)
    VALUES (p_nombre, p_apellido, p_especialidad);
END //

-- Leer Medico por ID
CREATE PROCEDURE LeerMedico (IN p_medico_id INT)
BEGIN
    SELECT * FROM Medico WHERE medico_id = p_medico_id;
END //

-- Leer Todos los Medicos
CREATE PROCEDURE LeerTodosMedicos ()
BEGIN
    SELECT * FROM Medico;
END //

-- Actualizar Medico
CREATE PROCEDURE ActualizarMedico (
    IN p_medico_id INT,
    IN p_nombre VARCHAR(80),
    IN p_apellido VARCHAR(80),
    IN p_especialidad VARCHAR(80)
)
BEGIN
    UPDATE Medico
    SET nombre = p_nombre,
        apellido = p_apellido,
        especialidad = p_especialidad
    WHERE medico_id = p_medico_id;
END //

-- Eliminar Medico
CREATE PROCEDURE EliminarMedico (IN p_medico_id INT)
BEGIN
    DELETE FROM Medico WHERE medico_id = p_medico_id;
END //

DELIMITER ; 

DELIMITER //

-- CREAR DISPONIBILIDAD
CREATE PROCEDURE CrearDisponibilidad (
    IN p_dia ENUM('lunes','martes','miercoles','jueves','viernes','sabado','domingo'),
    IN p_medico_id INT
)
BEGIN
    INSERT INTO Disponibilidad (dia, medico_id)
    VALUES (p_dia, p_medico_id);
END //

-- Leer Disponibilidad por ID
CREATE PROCEDURE LeerDisponibilidad (IN p_disponibilidad_id INT)
BEGIN
    SELECT * FROM Disponibilidad WHERE disponibilidad_id = p_disponibilidad_id;
END //

-- Leer Todas las Disponibilidades
CREATE PROCEDURE LeerTodasDisponibilidades ()
BEGIN
    SELECT * FROM Disponibilidad;
END //

-- Actualizar Disponibilidad
CREATE PROCEDURE ActualizarDisponibilidad (
    IN p_disponibilidad_id INT,
    IN p_dia ENUM('lunes','martes','miercoles','jueves','viernes','sabado','domingo'),
    IN p_medico_id INT
)
BEGIN
    UPDATE Disponibilidad
    SET dia = p_dia,
        medico_id = p_medico_id
    WHERE disponibilidad_id = p_disponibilidad_id;
END //

-- Eliminar Disponibilidad
CREATE PROCEDURE EliminarDisponibilidad (IN p_disponibilidad_id INT)
BEGIN
    DELETE FROM Disponibilidad WHERE disponibilidad_id = p_disponibilidad_id;
END //

DELIMITER ;

DELIMITER //

-- CREAR PACIENTE
CREATE PROCEDURE CrearPaciente (
    IN p_nombre VARCHAR(80),
    IN p_apellido VARCHAR(80),
    IN p_edad INT,
    IN p_telefono VARCHAR(80),
    IN p_contacto_emergencia VARCHAR(80)
)
BEGIN
    INSERT INTO Paciente (nombre, apellido, edad, telefono, contacto_emergencia)
    VALUES (p_nombre, p_apellido, p_edad, p_telefono, p_contacto_emergencia);
END //

-- Leer Paciente por ID
CREATE PROCEDURE LeerPaciente (IN p_paciente_id INT)
BEGIN
    SELECT * FROM Paciente WHERE paciente_id = p_paciente_id;
END //

-- Leer Todos los Pacientes
CREATE PROCEDURE LeerTodosPacientes ()
BEGIN
    SELECT * FROM Paciente;
END //

-- Actualizar Paciente
CREATE PROCEDURE ActualizarPaciente (
    IN p_paciente_id INT,
    IN p_nombre VARCHAR(80),
    IN p_apellido VARCHAR(80),
    IN p_edad INT,
    IN p_telefono VARCHAR(80),
    IN p_contacto_emergencia VARCHAR(80)
)
BEGIN
    UPDATE Paciente
    SET nombre = p_nombre,
        apellido = p_apellido,
        edad = p_edad,
        telefono = p_telefono,
        contacto_emergencia = p_contacto_emergencia
    WHERE paciente_id = p_paciente_id;
END //

-- Eliminar Paciente
CREATE PROCEDURE EliminarPaciente (IN p_paciente_id INT)
BEGIN
    DELETE FROM Paciente WHERE paciente_id = p_paciente_id;
END //

DELIMITER ;

DELIMITER //

-- Crear Cita
DELIMITER //

CREATE PROCEDURE CrearCita (
    IN p_medico_id INT,
    IN p_paciente_id INT,
    IN p_estado ENUM('Programado', 'Cancelado'),
    IN p_fecha DATE,
    IN p_comentario VARCHAR(200)
)
BEGIN
    -- Asignar valor por defecto a estado si es NULL
    IF p_estado IS NULL THEN
        SET p_estado = 'Programado';
    END IF;

    INSERT INTO Cita (medico_id, paciente_id, estado, fecha, comentario)
    VALUES (p_medico_id, p_paciente_id, p_estado, p_fecha, p_comentario);
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE LeerCita (
    IN p_cita_id INT
)
BEGIN
    SELECT * FROM Cita WHERE cita_id = p_cita_id;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE LeerTodasCitas ()
BEGIN
    SELECT * FROM Cita;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE ActualizarCita (
    IN p_cita_id INT,
    IN p_medico_id INT,
    IN p_paciente_id INT,
    IN p_estado ENUM('Programado', 'Cancelado'),
    IN p_fecha DATE,
    IN p_comentario VARCHAR(200)
)
BEGIN
    -- Asignar valor por defecto a estado si es NULL
    IF p_estado IS NULL THEN
        SET p_estado = 'Programado';
    END IF;

    UPDATE Cita
    SET medico_id = p_medico_id,
        paciente_id = p_paciente_id,
        estado = p_estado,
        fecha = p_fecha,
        comentario = p_comentario
    WHERE cita_id = p_cita_id;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE EliminarCita (
    IN p_cita_id INT
)
BEGIN
    DELETE FROM Cita WHERE cita_id = p_cita_id;
END //

DELIMITER ;

DELIMITER //

-- Crear Resultado
CREATE PROCEDURE CrearResultado (
    IN p_cita_id INT,
    IN p_procedimiento TEXT,
    IN p_recomendaciones TEXT,
    IN p_medicacion TEXT
)
BEGIN
    INSERT INTO Resultado (cita_id, procedimiento, recomendaciones, medicacion)
    VALUES (p_cita_id, p_procedimiento, p_recomendaciones, p_medicacion);
END //

-- Leer Resultado por ID
CREATE PROCEDURE LeerResultado (IN p_resultado_id INT)
BEGIN
    SELECT * FROM Resultado WHERE resultado_id = p_resultado_id;
END //

-- Leer Todos los Resultados
CREATE PROCEDURE LeerTodosResultados ()
BEGIN
    SELECT * FROM Resultado;
END //

-- Actualizar Resultado
CREATE PROCEDURE ActualizarResultado (
    IN p_resultado_id INT,
    IN p_cita_id INT,
    IN p_procedimiento TEXT,
    IN p_recomendaciones TEXT,
    IN p_medicacion TEXT
)
BEGIN
    UPDATE Resultado
    SET cita_id = p_cita_id,
        procedimiento = p_procedimiento,
        recomendaciones = p_recomendaciones,
        medicacion = p_medicacion
    WHERE resultado_id = p_resultado_id;
END //

-- Eliminar Resultado
CREATE PROCEDURE EliminarResultado (IN p_resultado_id INT)
BEGIN
    DELETE FROM Resultado WHERE resultado_id = p_resultado_id;
END //

DELIMITER ;


-- Traer agenda de algun medioc
delimiter//
create procedure traerAgenda(in id_medico int)
begin
	select * from cita
	where medico_id = id_medico;
end //
delimiter ;

--Ingreso de datos (hay problemas con el id medico 2)

INSERT INTO Medico (nombre, apellido, especialidad) VALUES 
('Juan', 'Perez', 'Cardiología'),
('María', 'Lopez', 'Neurología'),
('Pedro', 'Gomez', 'Pediatría'),
('Ana', 'Martinez', 'Dermatología'),
('Luis', 'Garcia', 'Oftalmología'),
('Sofia', 'Rodriguez', 'Ginecología'),
('Carlos', 'Hernandez', 'Psiquiatría'),
('Laura', 'Jimenez', 'Ortopedia'),
('Miguel', 'Fernandez', 'Endocrinología'),
('Julia', 'Torres', 'Oncología');

INSERT INTO Disponibilidad (dia, medico_id) VALUES 
('viernes', 3),
('sabado', 3),
('domingo', 4),
('lunes', 4),
('martes', 5),
('miercoles', 5),
('jueves', 6),
('viernes', 6),
('sabado', 7),
('domingo', 7),
('lunes', 8),
('martes', 8),
('miercoles', 9),
('jueves', 9),
('viernes', 10),
('sabado', 10);

INSERT INTO Paciente (nombre, apellido, edad, telefono, contacto_emergencia) VALUES 
('Carlos', 'Morales', 45, '555-1234', 'Ana Morales'),
('Lucia', 'Sanchez', 34, '555-5678', 'Pedro Sanchez'),
('Raul', 'Mendoza', 29, '555-8765', 'Sara Mendoza'),
('Marta', 'Vega', 53, '555-4321', 'Luis Vega'),
('Juan', 'Nunez', 22, '555-2345', 'Laura Nunez'),
('Ana', 'Ruiz', 37, '555-6789', 'Carlos Ruiz'),
('Pedro', 'Ponce', 41, '555-9876', 'Maria Ponce'),
('Laura', 'Castro', 26, '555-3456', 'Miguel Castro'),
('Jose', 'Ortega', 55, '555-5432', 'Marta Ortega'),
('Elena', 'Diaz', 33, '555-8767', 'Juan Diaz');


INSERT INTO Cita (medico_id, paciente_id, estado, fecha, comentario) VALUES 
(1, 1, 'Programado', '2024-07-01', 'Traer estudios previos'),
(3, 3, 'Cancelado', '2024-07-03', 'Reprogramar cita'),
(4, 4, 'Programado', '2024-07-04', 'Traer ropa holgada'),
(5, 5, 'Programado', '2024-07-05', 'Venir con un acompañante'),
(6, 6, 'Programado', '2024-07-06', 'Traer estudios previos'),
(7, 7, 'Programado', '2024-07-07', 'Ayuno de 8 horas'),
(8, 8, 'Cancelado', '2024-07-08', 'Reprogramar cita'),
(9, 9, 'Programado', '2024-07-09', 'Traer ropa holgada'),
(10, 10, 'Programado', '2024-07-10', 'Venir con un acompañante');





