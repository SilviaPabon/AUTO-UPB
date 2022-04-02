const controller = {};
const pool = require('../database/connection');
const helpers = require('../libs/helpers');

const { promisify } = require('util');
const exec = promisify(require('child_process').exec);
const childProcess = require('child_process'); 

controller.home = async (req, res) => {
    // Se obtienen los productos en descuento
    const disccountProducts = await pool.query('CALL SHOW_TOP_DISCOUNT()');

    // Se obtienen los productos top más vendidos
    const featuredProducts = await pool.query('CALL SHOW_TOP_SALES()');

    const data = {
        disccountProducts,
        featuredProducts,
    };

    res.render('index', { data });
};

controller.accessories = async (req, res) => {
    const products = await pool.query('CALL SHOW_ACCESSORIES');
    res.render('products', { products });
};

controller.accessoryDetails = async (req, res) => {
    const { id } = req.params;

    const product = await pool.query('CALL SHOW_ACCESSORY_DETAILS(?)', [id]);

    if (product[0].length != 0) {
        res.render('productDetails', { product });
    } else {
        req.flash('message', 'ERROR: No se encontró el accesorio solicitado');
        res.redirect('/');
    }
};

controller.userUpdate = async (req, res) => {
    const userd = await pool.query('CALL GET_USER_DATA_FROM_ID (?)', [req.user.id_usuario]);
    res.render('userUpdate', { userd });
};
controller.userUpdate_post = async (req, res) => {
    const { email, phone, address, password } = req.body;
    const encPassword = await helpers.encryptPassword(password);
    const emailExist = await pool.query('CALL USER_EXIST(?)', [email]);
    if (emailExist[0][0]['CONTEO'] == 0 || (emailExist[0][0]['CONTEO'] = 1 && req.user.correo_electronico == email)) {
        await pool.query('CALL UPDATE_EXISTING_USER(?,?,?,?,?,?)', [
            req.user.id_usuario,
            req.user.id_usuario,
            email,
            address,
            phone,
            encPassword,
        ]);
        req.flash('success', 'Datos actualizados exitosamente');
        req.user;
        res.redirect('/');
    } else {
        req.user;
        req.flash('message', 'El correo ' + email + ' ya está en uso');
        res.redirect('/update');
    }
};

controller.contactUs = async (req, res) => {
    res.render('contact_us');
};
controller.contactUspost = async (req, res) => {
    const { name, email, message } = req.body;
    let queryOk = false;

    try {
        await pool.query('CALL REGISTER_NEW_MESSAGE(?,?,?)', [name, email, message]);
        success = true;
    } catch (error) {
        success = false;
    }

    if (success) {
        req.flash('success', 'Mensaje registrado');
        res.redirect('/');
    } else {
        req.flash(
            'message',
            'Ocurrió un error inesperado al registrar el mensaje. Error común: Usar emojis en el contenido del mensaje'
        );
        res.redirect('/');
    }
};

/* --------------------------------
Ruta para abrir el cliente de correo Thunderbird en la ruta de instalación default
*/
controller.openMail = async (req, res) => {
    //Variables de control para la búsqueda del ejecutable de Thunderbird
    let execExist = false;
    let route = '';

    //Variable de control para la ejecución del servicio de Thunderbird
    let proccessOK = true;

    //Buscar si existe el archivo dentro del Disco C
    try {
        route = await exec('where /f /r "C:\\Program Files" thunderbird.exe');
        execExist = true;
    } catch (error) {
        req.flash('message', 'ERROR: No se ha encontrado el ejecutable de Thunderbird dentro del directorio por defecto C:Program Files');
        execExist = false;
    }

    //Si el archivo ejecutable existe, inicia el proceso
    if(execExist) {
        childProcess.execFile(`${route.stdout.slice(1, -2).slice(0, -1)}`, (error, stdout, stderr) => {
            if(error){
                req.flash('message', 'ERROR: No se ha podido iniciar el cliente de correo Thunderbird')
                proccessOK = false; 
            }
            if(stderr){
                req.flash('message', 'ERROR: No se ha podido iniciar el cliente de correo Thunderbird')
                proccessOK = false; 
            }
        });
    }else{
        proccessOK = false;
    }

    /*Si el proceso pudo iniciar satisfactoriamente, retorna al home y muestra el aviso*/
    if (proccessOK) {
        req.flash('success', 'El cliente de correo Thunderbird ha sido abierto satisfactoriamente');
        res.redirect('/');
    } else {
        res.redirect('/');
    }
};

module.exports = controller;
