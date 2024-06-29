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

 ## Instrucciones de instalacion y configuracion.

1. Clonar Repositorio   
 ```bash
 git clone https://github.com/GianMontemarani/bdd2-grupo7
```
2. Iniciar MySQL workbench y correr la query .sql dentro de la carpeta de este repositorio. [link](https://github.com/GianMontemarani/bdd2-grupo7/blob/master/Documentos/Creaci%C3%B3nTablas_y_StoredProcedures.sql)

3. Iniciar la aplicacion MongoDB compass o Atlas.
4. Iniciar la apliacion de Postman
5. La aplicacion reponde a las siguientes queries HTTP en Postman (los valores de la BD son a modo de ejemplo).

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
</details>

<details>
 <summary><code>GET</code> <code><b>.../</b></code> <code>getAgendaMedico?id={int} (Devuelve la agenda de un medico )</code></summary>

##### Parametros
id int;
##### Respuesta JSON
```bash
[
    [
        {
            "cita_id": 11,
            "medico_id": 1,
            "paciente_id": 1,
            "estado": "Programado",
            "fecha": "2024-07-01T03:00:00.000Z",
            "comentario": "Traer estudios previos"
        }
    ],
    {
        "fieldCount": 0,
        "affectedRows": 0,
        "insertId": 0,
        "info": "",
        "serverStatus": 2,
        "warningStatus": 0,
        "changedRows": 0
    }
]
```

</details>




</details>

<details>
 <summary><code>GET</code> <code><b>.../</b></code> <code>getPacientes (Devuelve todos los pacientes de la BD)</code></summary>

##### Parametros
Ninguno
##### Respuesta JSON
```bash
[
    [
        {
            "paciente_id": 1,
            "nombre": "Carlos",
            "apellido": "Morales",
            "edad": 45,
            "telefono": "555-1234",
            "contacto_emergencia": "Ana Morales"
        },
        {
            "paciente_id": 2,
            "nombre": "Lucia",
            "apellido": "Sanchez",
            "edad": 34,
            "telefono": "555-5678",
            "contacto_emergencia": "Pedro Sanchez"
        },
        {
            "paciente_id": 3,
            "nombre": "Raul",
            "apellido": "Mendoza",
            "edad": 29,
            "telefono": "555-8765",
            "contacto_emergencia": "Sara Mendoza"
        },
        {
            "paciente_id": 4,
            "nombre": "Marta",
            "apellido": "Vega",
            "edad": 53,
            "telefono": "555-4321",
            "contacto_emergencia": "Luis Vega"
        },
        {
            "paciente_id": 5,
            "nombre": "Juan",
            "apellido": "Nunez",
            "edad": 22,
            "telefono": "555-2345",
            "contacto_emergencia": "Laura Nunez"
        },
        {
            "paciente_id": 6,
            "nombre": "Ana",
            "apellido": "Ruiz",
            "edad": 37,
            "telefono": "555-6789",
            "contacto_emergencia": "Carlos Ruiz"
        },
        {
            "paciente_id": 7,
            "nombre": "Pedro",
            "apellido": "Ponce",
            "edad": 41,
            "telefono": "555-9876",
            "contacto_emergencia": "Maria Ponce"
        },
        {
            "paciente_id": 8,
            "nombre": "Laura",
            "apellido": "Castro",
            "edad": 26,
            "telefono": "555-3456",
            "contacto_emergencia": "Miguel Castro"
        },
        {
            "paciente_id": 9,
            "nombre": "Jose",
            "apellido": "Ortega",
            "edad": 55,
            "telefono": "555-5432",
            "contacto_emergencia": "Marta Ortega"
        },
        {
            "paciente_id": 10,
            "nombre": "Elena",
            "apellido": "Diaz",
            "edad": 33,
            "telefono": "555-8767",
            "contacto_emergencia": "Juan Diaz"
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

</details>



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



