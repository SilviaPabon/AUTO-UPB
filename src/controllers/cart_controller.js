const controller = {};
const connection = require('../database/connection');

// Controlador de la ruta para añadir accesorios al carrito de compras
controller.cartAdd = async (req, res) => {
    const { id } = req.body;

    // Inicializa la variable de control
    let success = false;

    try {
        // Ejecuta la llamada al procedimiento almacenado para añadir el accesorio al carrito
        const query = await connection.query('CALL ADD_ACCESSORY_CART(?, ?)', [req.user.id_usuario, id]);

        if (query[0][0]['@success'] == 1) {
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

// Controlador de la ruta para elimiar accesorios del carrito
controller.cartRemoveGet = async (req, res) => {
    const { id } = req.params;
    let success = false;

    try {
        // Ejecuta la llamada al procedimiento almacenado para eliminar el accesorio del carrito

        await connection.query('CALL REMOVE_ACCESSORY_CART(?, ?)', [req.user.id_usuario, id]);
        success = true;
    } catch (error) {
        success = false;
    }

    if (success) {
        req.flash('success', 'Operación exitosa: El accesorio fue removido del carrito');
        res.redirect('/cart');
    } else {
        req.flash('message', 'Error: El accesorio a eliminar no fue encontrado en el carrito');
        res.redirect('/cart');
    }
};

// Controlador de la ruta para mostrar el carrito de compras
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

    res.render('shop/shopping_cart', { cart, resume });
};

// Controlador de la ruta para actualizar el número de itemes de un accesorio en el carrito
controller.cartUpdate = async (req, res) => {
    const { id, amount } = req.body;

    // Inicializa la variable de control
    let success = false;

    // Ejecuta la sentencia para actualizar el carrito en la base de datos
    try {
        connection.query('CALL MODIFY_AMOUNT_ACCESSORY_CART(?, ?, ?)', [req.user.id_usuario, id, amount]);
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

// Controlador de la ruta para emitir órden de compra
controller.orderClientPost = async (req, res) => {
    let orderStepSuccess = false;

    const order = {
        id_orden: -1,
    };

    try {
        const newBuyOrderQuery = await connection.query('CALL REGISTER_NEW_BUY_ORDER(?, ?)', [
            req.user.id_usuario,
            req.user.id_usuario,
        ]);
        order.id_orden = newBuyOrderQuery[0][0].id_orden;
        orderStepSuccess = true;
    } catch (error) {
        orderStepSuccess = false;
    }

    if (orderStepSuccess) {
        const transactionQuery = await connection.query('CALL register_buy_order_from_cart(?, ?)', [
            req.user.id_usuario,
            order.id_orden,
        ]);

        if (transactionQuery[0] == undefined) {
            req.flash('success', 'Proceso exitoso: Se generó la orden de compra de manera exitosa');
            res.redirect('/user/orders');
        } else {
            req.flash(
                'message',
                `Error: El stock del accesorio ${transactionQuery[0][0].nombre} es ${transactionQuery[0][0].stock}`
            );
            res.redirect('/cart');
        }
    }
};

module.exports = controller;
