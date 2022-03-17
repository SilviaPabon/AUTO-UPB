const controller = {};
const { response } = require('express');
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
    const { name, documento, email, phone, address, password, conditions } = req.body;

    // Si ya existe el usuario en la base de datos toma su id (Revisa si ya existe el correo o el documento)

    res.send('Received');
};

module.exports = controller;
