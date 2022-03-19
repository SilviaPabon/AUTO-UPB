const controller = {};
const helpers = require('../libs/helpers');
const connection = require('../database/connection');

// ------
// Ruta get usada para mostrar el carrito
controller.showCart = async (req, res) => {
    // Traer el carrito que corresponda al usuario desde la BD
    const cartFromDB = await connection.query('CALL GET_ACCESSORY_CART(?)', [req.user.id_usuario]);
    const cOrig = cartFromDB[0];

    // Variables locales del carrito y el resumen de la compra
    const cart = [];
    const resume = {};
    resume.descuentos = 0;

    // Iterar el carrito para llevar los datos al front
    for (let index = 0; index < cOrig.length; index++) {
        cart[index] = {};
        cart[index].id_accesorio = cOrig[index].id_accesorio;
        cart[index].nombre = cOrig[index].nombre;
        cart[index].precio_base = cOrig[index].precio_base;
        cart[index].descuento = cOrig[index].descuento;
        cart[index].precio_final = cOrig[index].precio_final * cOrig[index].cantidad_accesorio;
        cart[index].cantidad = cOrig[index].cantidad_accesorio;
        cart[index].stock = cOrig[index].stock;

        if (cart[index].descuento > 0) {
            resume.descuentos += cart[index].precio_base * cart[index].cantidad - cart[index].precio_final;
        }
    }

    // Calculos finales para el resumen de compra
    resume.subtotal = cart.map((item) => item.precio_final).reduce((prev, curr) => prev + curr, 0);
    resume.impuestos = resume.subtotal * 0.19;
    resume.total = resume.subtotal + resume.impuestos;

    res.render('shop/employee_shopping_cart', { cart, resume });
};

// ----
// Ruta para obtener los datos de un usuario si existe
controller.user_exists = async (req, res) => {
    const { documento } = req.body;
    let response;
    let success = false;

    try {
        response = await connection.query('CALL GET_USER_DATA_BUY_ORDER(?)', [documento]);
        success = true; 
    } catch (error) {
        success = false;
    }

    success == true ? res.status(200).send(response[0]) : res.status(500).send([]);
};

// ----
// Ruta para enviar los datos del cliente y proceder con la orden
controller.postOrder = async (req, res) => {

    //Variables de control
    let userStepSuccess = false; 
    let orderStepSuccess = false; 

    //Recibimiento y organización de los datos
    const { id_usuario, name, documento, email, phone, address, password, conditions } = req.body;

    const user = {
        id_usuario,
        name, 
        documento, 
        email, 
        phone, 
        address, 
        password, 
        conditions
    }

    const order = {
        id_orden: -1
    }

    user.conditions = user.conditions == 'on' ? 1 : 0;

    if(user.id_usuario != -1){
        //Si el usuario existe, verifica que la contraseña sea correcta
        const userPassword = await connection.query('CALL GET_USER_PASSWORD(?)', [user.email]); 
        const passwordsAreEqual = await helpers.matchPassword(user.password, userPassword[0][0].contraseña);

        if(passwordsAreEqual){
            userStepSuccess = true; 
        }else{
            req.flash('message', 'Error: La contraseña del usuario no coincide');
            res.redirect('/employee/cart'); 
        }
    }else{
        //Si el usuario no existe, lo crea en la base de datos y obtiene su id

        //Se encripta la contraseña para su almacenamiento en la base de datos
        user.password = await helpers.encryptPassword(user.password); 

        //Se realiza el registro
        const newUserQuery = await connection.query('CALL REGISTER_NEW_CLIENT(?, ?, ?, ?, ?, ?, ?)', [
            user.name, 
            user.documento, 
            user.email, 
            user.address, 
            user.phone, 
            user.conditions, 
            user.password
        ]); 

        //Reemplaza el id que estaba como -1 al nuevo id del usuario creado
        user.id_usuario = newUserQuery[0][0].id_usuario; 

        userStepSuccess = true; 
    }


    //Si el paso del cliente salió bien, se crea la orden de compra a nombre de ese cliente
    if(userStepSuccess){
        const newBuyOrderQuery = await connection.query('CALL REGISTER_NEW_BUY_ORDER(?, ?)', [req.user.id_usuario, user.id_usuario]); 
        order.id_orden = newBuyOrderQuery[0][0].id_orden; 
        orderStepSuccess = true; 
    }


    //Una vez se cree la orden de compra, se comienza la transacción de registro de la orden
    if(orderStepSuccess){
        const transactionQuery = await connection.query('CALL register_buy_order_from_cart(?, ?)', [req.user.id_usuario, order.id_orden]); 

        if(transactionQuery[0] == undefined){
            req.flash('success', 'Proceso exitoso: Se generó la orden de compra de manera exitosa');
            res.redirect('/employee/cart'); 
        }else{
            req.flash('message', `Error: El stock del accesorio ${transactionQuery[0][0].nombre} es ${transactionQuery[0][0].stock}`);
            res.redirect('/employee/cart'); 
        }
    }
};

module.exports = controller;
