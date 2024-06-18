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

app.get('/getCitasMedico:id', (req, res) => {
    //Recibe el id del medico y devuelve todas las citas programadas
});

app.post('/setCita', (req, res) => {
    //Recibe el id del medico, el id del paciente y la fecha de la cita
});

app.post('/deleteCita', (req, res) => {
    //Recibe el id de la cita y la elimina
});

app.post('/updateCita', (req, res) => {
    //Recibe el id de la cita y la actualiza con los nuevos datos
});

app.get('/consultaPaciente', (req, res) => {
    //Recibe el documento de un paciente y devuelve su historial medico
});

app.post('/addHistorial', (req, res) => {
    //Recibe un documento nuevo para el historial y lo agrega a la collecion de historial medico
});

app.post('/addTratamiento', (req, res) => {
    //Recibe un documento nuevo de tratamiento y lo agrega a la collecion de tratamientos
});

app.get('/getMedicos', (req, res) => {

});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});