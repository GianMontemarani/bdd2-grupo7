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




