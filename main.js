const express = require('express');
const mongoose = require('mongoose');
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();

const app = express();

app.use(express.json());

mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
}).then(() => {
    console.log('Conectado a MongoDB');
}).catch((error) => {
    console.error('Error conectando a MongoDB', error);
    process.exit(1);
});

const dbMongo = mongoose.connection;

const pool = mysql.createPool({
    host: process.env.SQL_HOST,
    user: process.env.SQL_USER,
    password: process.env.SQL_PASSWORD,
    database: process.env.SQL_DATABASE,
});

pool.getConnection((err, connection) => {
    if (err) {
        console.error('Error conectando a MySQL', err);
        process.exit(1);
    }
    if (connection) connection.release();
    console.log('Conectado a MySQL');
});

app.get('/getMedicos', (req, res) => {
    pool.query('call mostrarMedicos()', (err, result) => {
        if (err) {
            console.error('Error consultando medicos', err);
            res.status(500).send('Error consultando medicos');
        } else {
            res.json(result);
        }
    });
});

app.get('/getAgendaMedico', (req, res) => {
    let id = req.query.id;
    pool.query('call traerAgenda(?)', [id], (err, result) => {
        if (err) {
            console.error('Error consultando citas', err);
            res.status(500).send('Error consultando citas');
        } else {
            res.json(result);
        }
    });
});

app.get('/getPacientes', (req, res) => {
    pool.query('call LeerTodosPacientes()', (err, result) => {
        if (err) {
            console.error('Error consultando pacientes', err);
            res.status(500).send('Error consultando pacientes');
        } else {
            res.json(result);
        }
    });
});

app.get('/getCitasPaciente', (req, res) => {
    let id = req.query.id;
    pool.query('SELECT * FROM Cita WHERE paciente_id = ?', [id], (err, result) => {
        if (err) {
            console.error('Error consultando citas', err);
            res.status(500).send('Error consultando citas');
        } else {
            res.json(result);
        }
    });
});

app.post('/agendar', (req, res) => {
    let { id_medico, id_paciente, fecha, comentario } = req.body;
    fecha = new Date(fecha).toISOString().slice(0, 19).replace('T', ' ');

    pool.query('SELECT * FROM Medico WHERE medico_id = ? LIMIT 1', [id_medico], (err, result) => {
        if (err) {
            console.error('Error consultando medico', err);
            res.status(500).send('Error consultando medico');
        } else {
            if (result.length === 0) {
                res.status(404).send('Medico no encontrado');
            } else {
                pool.query('SELECT * FROM Paciente WHERE paciente_id = ? LIMIT 1', [id_paciente], (err, result) => {
                    if (err) {
                        console.error('Error consultando paciente', err);
                        res.status(500).send('Error consultando paciente');
                    } else {
                        if (result.length === 0) {
                            res.status(404).send('Paciente no encontrado');
                        } else {
                            pool.query('SELECT dia FROM Disponibilidad WHERE medico_id = ?', [id_medico], (err, result) => {
                                if (err) {
                                    console.error('Error consultando disponibilidad', err);
                                    res.status(500).send('Error consultando disponibilidad');
                                } else {
                                    let dia = new Date(fecha).getDay();
                                    let diasString = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'];
                                    if (result.length === 0 || !result.find((d) => d.dia === diasString[dia - 1])) {
                                        res.status(400).send('El medico no esta disponible en ese dia');
                                    }else{
                                        pool.query('call CrearCita(?,?,"Programado",?,?)', [id_medico, id_paciente, fecha, comentario], (err, result) => {
                                            if (err) {
                                                console.error('Error insertando cita', err);
                                                res.status(500).send('Error insertando cita');
                                            } else {
                                                res.json(result);
                                            }
                                        });
                                    }
                                }
                            });
                        }
                    }
                });
            }
        }
    });
});

app.post('/cancelarCita', (req, res) => {
    let { id_cita } = req.body;
    pool.query('UPDATE Cita SET estado = "Cancelado" WHERE cita_id = ?;', [id_cita], (err, result) => {
        if (err) {
            console.error('Error cancelando cita', err);
            res.status(500).send('Error cancelando cita');
        } else {
            res.json(result);
        }
    });
});

app.post('/modificarCita', (req, res) => {
    let { id_cita, fecha, comentario } = req.body;
    fecha = new Date(fecha).toISOString().slice(0, 19).replace('T', ' ');

    pool.query('SELECT * FROM Cita WHERE cita_id = ? LIMIT 1', [id_cita], (err, result) => {
        if (err) {
            console.error('Error consultando cita', err);
            res.status(500).send('Error consultando cita');
        } else {
            if (result.length === 0) {
                res.status(404).send('Cita no encontrada');
            } else {
                let cita = result[0];
                pool.query('call ActualizarCita(?,?,?,?,?,?)', [id_cita, cita.medico_id, cita.paciente_id, cita.estado, cita.fecha, comentario], (err, result) => {
                    if (err) {
                        console.error('Error modificando cita', err);
                        res.status(500).send('Error modificando cita');
                    } else {
                        res.json(result);
                    }
                });
            }
        }
    });
});

app.get('/getDocumentos', (req, res) => {
    let id_paciente = req.query.id_paciente;
    let tipo_documento = req.query.tipo_documento;

    let documentos = dbMongo.collection(tipo_documento).find({ id_paciente }).toArray();
    documentos.then((documentos) => {
        res.json(documentos);
    }).catch((error) => {
        console.error('Error consultando documentos', error);
        res.status(500).send('Error consultando documentos');
    });
});

app.post('/subirDoc', (req, res) => {
    let { id_paciente, id_medico, tipo } = req.body;

    pool.query('SELECT * FROM Paciente WHERE paciente_id = ? LIMIT 1', [id_paciente], (err, result) => {
        if (err) {
            console.error('Error consultando paciente', err);
            res.status(500).send('Error consultando paciente');
        } else {
            if (result.length === 0) {
                res.status(404).send('Paciente no encontrado');
            } else {
                pool.query('SELECT * FROM Medico WHERE medico_id = ? LIMIT 1', [id_medico], (err, result) => {
                    if (err) {
                        console.error('Error consultando medico', err);
                        res.status(500).send('Error consultando medico');
                    } else {
                        if (result.length === 0) {
                            res.status(404).send('Medico no encontrado');
                        } else {
                            let fecha = new Date().toISOString().slice(0, 19).replace('T', ' ');
                            let documento = { fecha, ...req.body };
                            dbMongo.collection(tipo).insertOne(documento, (error, result) => {
                                if (error) {
                                    console.error('Error subiendo documento', error);
                                    res.status(500).send('Error subiendo documento');
                                } else {
                                    res.json(result);
                                }
                            });
                        }
                    }
                });
            }
        }
    });
});

app.get('/generarReporte', (req, res) => {
    let id_paciente = req.query.id_paciente;

    pool.query('SELECT * FROM Paciente WHERE paciente_id = ? LIMIT 1', [id_paciente], (err, result) => {
        if (err) {
            console.error('Error consultando paciente', err);
            res.status(500).send('Error consultando paciente');
        } else {
            if (result.length === 0) {
                res.status(404).send('Paciente no encontrado');
            } else {
                let paciente = result[0];
                let diagnosticos = dbMongo.collection('diagnostico').find({ id_paciente }).toArray();
                let hospitalizaciones = dbMongo.collection('hospitalizacion').find({ id_paciente }).toArray();
                let tratamientos = dbMongo.collection('tratamiento').find({ id_paciente }).toArray();

                Promise.all([diagnosticos, hospitalizaciones, tratamientos]).then(([diagnosticos, hospitalizaciones, tratamientos]) => {
                    let reporte = { paciente, diagnosticos, hospitalizaciones, tratamientos };
                    res.json(reporte);
                }).catch((error) => {
                    console.error('Error generando reporte', error);
                    res.status(500).send('Error generando reporte');
                });
            }
        }
    });
});

app.post('/nuevoMedico', (req, res) => {
    let { nombre, apellido, especialidad } = req.body;
    pool.query('call crearMedico(?,?,?)', [nombre, apellido, especialidad], (err, result) => {
        if (err) {
            console.error('Error creando medico', err);
            res.status(500).send('Error creando medico');
        } else {
            res.json(result);
        }
    });
});

app.post('/nuevoPaciente', (req, res) => {
    let { nombre, apellido, edad, telefono, contacto_emergencia } = req.body;
    pool.query('call CrearPaciente(?,?,?,?,?)', [nombre, apellido, edad, telefono, contacto_emergencia], (err, result) => {
        if (err) {
            console.error('Error creando paciente', err);
            res.status(500).send('Error creando paciente');
        } else {
            res.json(result);
        }
    });
});

app.post('/actualizarMedico', (req, res) => {
    let {id_medico, campo, valor} = req.body;

    pool.query('SELECT * FROM Medico WHERE medico_id = ? LIMIT 1', [id_medico], (err, result) => {
        if (err) {
            console.error('Error consultando medico', err);
            res.status(500).send('Error consultando medico');
        } else {
            if (result.length === 0) {
                res.status(404).send('Medico no encontrado');
            } else {
                pool.query('call modificarMedico(?,?,?)', [id_medico, campo, valor], (err, result) => {
                    if (err) {
                        console.error('Error actualizando medico', err);
                        res.status(500).send('Error actualizando medico');
                    } else {
                        res.json(result);
                    }
                });
            }
        }
    });
});

app.post('/actualizarPaciente', (req, res) => {
    let { id_paciente, nombre, apellido, edad, telefono, contacto_emergencia } = req.body;

    pool.query('SELECT * FROM Medico WHERE medico_id = ? LIMIT 1', [id_paciente], (err, result) => {
        if (err) {
            console.error('Error consultando paciente', err);
            res.status(500).send('Error consultando paciente');
        } else {
            if (result.length === 0) {
                res.status(404).send('Paciente no encontrado');
            } else {
                pool.query('call ActualizarPaciente(?,?,?,?,?,?)', [id_paciente, nombre, apellido, edad, telefono, contacto_emergencia], (err, result) => {
                    if (err) {
                        console.error('Error actualizando paciente', err);
                        res.status(500).send('Error actualizando paciente');
                    } else {
                        res.json(result);
                    }
                });
            }
        }
    });
});

app.post('/eliminarMedico', (req, res) => {
    let { id_medico } = req.body;

    pool.query('call EliminarMedico(?)', [id_medico], (err, result) => {
        if (err) {
            console.error('Error eliminando medico', err);
            res.status(500).send('Error eliminando medico');
        } else {
            res.json(result);
        }
    });
});

app.post('/eliminarPaciente', (req, res) => {
    let { id_paciente } = req.body;

    pool.query('call EliminarPaciente(?)', [id_paciente], (err, result) => {
        if (err) {
            console.error('Error eliminando paciente', err);
            res.status(500).send('Error eliminando paciente');
        } else {
            res.json(result);
        }
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});