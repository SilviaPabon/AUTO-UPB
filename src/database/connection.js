const mysql = require('mysql');
const { promisify } = require('util');
require('dotenv').config();

// Crear conexión con las credenciales asignadas
const pool = mysql.createPool({
    host: process.env.PRINCIPAL_DB_HOST, 
    database: process.env.PRINCIPAL_DB_NAME, 
    user: process.env.PRINCIPAL_DB_USER, 
    port: process.env.PRINCIPAL_DB_PORT, 
    password: process.env.PRINCIPAL_DB_PASSWORD
}); 

// Obtener la conexión
pool.getConnection((err, connection) => {

    //Si ocurre algún error
    if (err) {
        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            console.error('DATABASE CONECCTION WAS CLOSED');
        }
        if (err.code === 'ER_CON_COUNT_ERROR') {
            console.error('DATABASE HAS TO MANY CONNECTIONS');
        }
        if (err.code === 'ECONNREFUSED') {
            console.error('DATABASE CONNECTION WAS REFUSED');
        }
        if(err.code === 'ER_BAD_DB_ERROR'){
            console.error('DATABASE DOESN´T EXIST');
        }
    }

    //Si se obtiene la conexión
    if(connection) connection.release();

    console.log('CONEXIÓN CON LA BASE DE DATOS PRINCIPAL EXITOSA');
    return;
});

pool.query = promisify(pool.query); //allows promisify
module.exports = pool;