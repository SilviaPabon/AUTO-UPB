const controller = {};
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
            resume.descuentos += ((cart[index].precio_base * cart[index].cantidad) - cart[index].precio_final);
        }

    }

    // Calculos finales para el resumen de compra
    resume.subtotal = cart.map(item => item.precio_final).reduce((prev, curr) => prev + curr, 0);
    resume.impuestos = resume.subtotal * 0.19;
    resume.total = resume.subtotal + resume.impuestos;
    
    res.render('shop/employee_shopping_cart', {cart, resume});
};


module.exports = controller;
