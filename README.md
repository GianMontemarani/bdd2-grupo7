# Proyecto de Gestión de hospitales

![Static Badge](https://img.shields.io/badge/Grupo-07-blue)

El proyecto corresponde a un trabajo práctico grupal para la materia Ingeniería de Datos II en la Universidad Argentina de la Empresa. El mismo consistió en el desarrollo de una aplicción para la gestión de un hospital, teniendo como base la implementación de una persistncia políglota. Es decir, se utilizó una combinación de bases de datos SQL con NoSQL. En nuetsro caso, decidimos que la mejor opción era usar MySQL y MongoDB.

[![uadelogo.webp](https://i.postimg.cc/gkfGW6Fc/uadelogo.webp)](https://postimg.cc/w7cC5Mjn)
## Responsabilidades de cada base de datos

### MySQL
- Se encarga de la generación de citas a partir de los ID del paciente y del médico. También se debe consultar la disponibilidad del último.
- ABM (alta, baja o modificacion) de las entidades Médico, Disponibilidad, Paciente y Cita.

### MongoDB
- Se encarga de desarollar reportes a partir de las citas.
- Muestra un documento que exhibe el historial médico de cada paciente, el cual está formado por otros tres documentos: diagnóstico, tratamiento y hospitalización.

## Ayuda
En el caso de que no se pueda iniciar mySQL se debera correr el siguiente comando en la terminal del sistema operativo
> sudo /usr/local/mysql/support-files/mysql.server start
> 
> sudo /usr/local/mysql/support-files/mysql.server stop
> 
> sudo /usr/local/mysql/support-files/mysql.server restart
> 

[Link de la solucion original](https://stackoverflow.com/questions/41995912/macos-cant-start-mysql-server "Link de la solucion original")

## Tecnologías Utilizadas

![JavaScript Badge](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=white)
 ![Express.js Badge](https://img.shields.io/badge/Express.js-000000?logo=express&logoColor=white)
 ![MongoDB Badge](https://img.shields.io/badge/MongoDB-47A248?logo=mongodb&logoColor=white)
 ![MySQL Badge](https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=white)
 ![LaTeX Badge](https://img.shields.io/badge/LaTeX-008080?logo=latex&logoColor=white)

 ## Instrucciones de instalacion y configuracion.
 ```bash
 git clone https://github.com/GianMontemarani/bdd2-grupo7
```
Iniciar MySQL workbench y correr la query .sql dentro de la carpeta de este repositorio.
```bash
https://github.com/GianMontemarani/bdd2-grupo7/blob/master/Documentos/Creaci%C3%B3nTablas_y_StoredProcedures.sql
```
Iniciar la aplicacion MongoDB compass o Atlas.

La aplicacion reponde a las siguientes queries HTTP en Postman (los valores de la BD son a modo de ejemplo).

<details>
 <summary><code>GET</code> <code><b>.../</b></code> <code>getMedicos (Devuelve todos los medicos de la BD)</code></summary>

##### Parametros
Ninguno
##### Respuesta JSON
```bash
[
    [
        {
            "medico_id": 1,
            "nombre": "pepe",
            "apellido": "shnr",
            "especialidad": "traumatologo"
        },
        {
            "medico_id": 3,
            "nombre": "Juan",
            "apellido": "Perez",
            "especialidad": "Cardiología"
        },
        {
            "medico_id": 4,
            "nombre": "María",
            "apellido": "Lopez",
            "especialidad": "Neurología"
        },
        {
            "medico_id": 5,
            "nombre": "Pedro",
            "apellido": "Gomez",
            "especialidad": "Pediatría"
        },
        {
            "medico_id": 6,
            "nombre": "Ana",
            "apellido": "Martinez",
            "especialidad": "Dermatología"
        },
        {
            "medico_id": 7,
            "nombre": "Luis",
            "apellido": "Garcia",
            "especialidad": "Oftalmología"
        },
        {
            "medico_id": 8,
            "nombre": "Sofia",
            "apellido": "Rodriguez",
            "especialidad": "Ginecología"
        },
        {
            "medico_id": 9,
            "nombre": "Carlos",
            "apellido": "Hernandez",
            "especialidad": "Psiquiatría"
        },
        {
            "medico_id": 10,
            "nombre": "Laura",
            "apellido": "Jimenez",
            "especialidad": "Ortopedia"
        },
        {
            "medico_id": 11,
            "nombre": "Miguel",
            "apellido": "Fernandez",
            "especialidad": "Endocrinología"
        },
        {
            "medico_id": 12,
            "nombre": "Julia",
            "apellido": "Torres",
            "especialidad": "Oncología"
        }
    ],
    {
        "fieldCount": 0,
        "affectedRows": 0,
        "insertId": 0,
        "info": "",
        "serverStatus": 34,
        "warningStatus": 0,
        "changedRows": 0
    }
]
```

<details>
 <summary><code>GET</code> <code><b>.../</b></code> <code> getPacientes  (Devuelve todos los Pacientes de la BD)</code></summary>

##### Parametros
Ninguno
##### Respuesta JSON
```bash









