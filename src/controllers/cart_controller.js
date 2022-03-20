const controller = {};
const connection = require('../database/connection');

// -----------
// Ruta para añadir un accesorio al carrito
controller.cartAdd = async (req, res) => {
    const { id } = req.body;

    // Inicializa la variable de control
    let success = false;

    try {
        // Ejecuta la llamada al procedimiento almacenado para añadir el accesorio al carrito
        const query = await connection.query('CALL ADD_ACCESSORY_CART(?, ?)', [req.user.id_usuario, id]);
        
        if(query[0][0]['@success'] == 1){
            success = true; 
        }
        
    } catch (error) {
        success = false;
    }

    // Se envía la respuesta según si la operación fue exitosa o no
    success == true
        ? res.status(200).json({
                status: 'El accesorio fue agregado exitosamente',
        })
        : res.status(404).json({
            status: 'No se econtró el accesorio dado',
        });
};

// ------
// Ruta get usada por los botones para remover un accesorio del carrito
controller.cartRemoveGet = async (req, res) => {
    const { id } = req.params;
    let success = false;

    try {
        // Ejecuta la llamada al procedimiento almacenado para eliminar el accesorio del carrito

        const query = await connection.query('CALL REMOVE_ACCESSORY_CART(?, ?)', [req.user.id_usuario, id]);
        success = true;
        
    } catch (error) {
        success = false;
    }

    if (success) {
        req.flash('success', `Operación exitosa: El accesorio fue removido del carrito`);
        res.redirect('/cart');
    } else {
        req.flash('message', 'Error: El accesorio a eliminar no fue encontrado en el carrito');
        res.redirect('/cart');
    }
};

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
    
    res.render('shop/shopping_cart', {cart, resume});
};

// ------
// Ruta para actualizar el número de items de un accesorio del carrito
controller.cartUpdate = async (req, res) => {
    const { id, amount } = req.body;

    // Inicializa la variable de control
    let success = false;

    // Ejecuta la sentencia para actualizar el carrito en la base de datos
    try {
        const query = connection.query('CALL MODIFY_AMOUNT_ACCESSORY_CART(?, ?, ?)', [req.user.id_usuario, id, amount]); 
        success = true;
    } catch (error) {
        success = false;
    }

    // Se envía la respuesta según si la operación fue exitosa o no
    success == true
        ? res.status(200).json({
            status: 'La cantidad fue modificada exitosamente',
        })
        : res.status(500).json({
            status: 'La cantidad no pudo ser modificada',
        });
};

module.exports = controller;
