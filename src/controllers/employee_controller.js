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

// ------
// Ruta get usada por los botones para remover un accesorio del carrito
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
        res.redirect('/employee/cart');
    } else {
        req.flash('message', 'Error: El accesorio a eliminar no fue encontrado en el carrito');
        res.redirect('/employee/cart');
    }
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
        conditions,
    };

    const order = {
        id_orden: -1,
    };

    user.conditions = user.conditions == 'on' ? 1 : 0;

    if (user.id_usuario != -1) {
        //Si el usuario existe, verifica que la contraseña sea correcta
        const userPassword = await connection.query('CALL GET_USER_PASSWORD(?)', [user.email]);
        const passwordsAreEqual = await helpers.matchPassword(user.password, userPassword[0][0].contraseña);

        if (passwordsAreEqual) {
            userStepSuccess = true;
        } else {
            req.flash('message', 'Error: La contraseña del usuario no coincide');
            res.redirect('/employee/cart');
        }
    } else {
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
            user.password,
        ]);

        //Reemplaza el id que estaba como -1 al nuevo id del usuario creado
        user.id_usuario = newUserQuery[0][0].id_usuario;

        userStepSuccess = true;
    }

    //Si el paso del cliente salió bien, se crea la orden de compra a nombre de ese cliente
    if (userStepSuccess) {
        const newBuyOrderQuery = await connection.query('CALL REGISTER_NEW_BUY_ORDER(?, ?)', [
            req.user.id_usuario,
            user.id_usuario,
        ]);
        order.id_orden = newBuyOrderQuery[0][0].id_orden;
        orderStepSuccess = true;
    }

    //Una vez se cree la orden de compra, se comienza la transacción de registro de la orden
    if (orderStepSuccess) {
        const transactionQuery = await connection.query('CALL register_buy_order_from_cart(?, ?)', [
            req.user.id_usuario,
            order.id_orden,
        ]);

        if (transactionQuery[0] == undefined) {
            req.flash('success', 'Proceso exitoso: Se generó la orden de compra de manera exitosa');
            res.redirect('/employee/cart');
        } else {
            req.flash(
                'message',
                `Error: El stock del accesorio ${transactionQuery[0][0].nombre} es ${transactionQuery[0][0].stock}`
            );
            res.redirect('/employee/cart');
        }
    }
};

// ---
// Ruta para mostrar el inventario existente
controller.inventory = async (req, res) => {
    const inventory = await connection.query('CALL SHOW_ACCESSORIES_INTERNAL(?)', [req.user.id_usuario]);
    const data = {
        ACCESORIOS: inventory[0],
        isFiltered: false,
    };
    res.render('employees/employee_show_inventory', {
        data,
    });
};

// ---
// Ruta post para buscar un accesorio
controller.searchinventory = async (req, res) => {
    //se toma como "criteria" la busqueda que se haga desde la barra de navegacion
    const { criteria } = req.body;
    res.redirect(`/employee/inventory/${criteria}`);
};

// ----
// Ruta para mostrar el resultado de búsqueda de accesorio
controller.searchinventoryResult = async (req, res) => {
    const { criteria } = req.params;

    const inventory = await connection.query('CALL SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL(?, ?)', [
        req.user.id_usuario,
        criteria,
    ]);

    const data = {
        ACCESORIOS: inventory[0],
        isFiltered: true,
        criteria,
    };

    res.render('employees/employee_show_inventory', { data });
};

controller.showorders = async (req, res) => {
    let queryOk = false;

    try {
        var clientOrders = await connection.query('CALL GETALL_USER_ORDERBUY(?)', [req.user.id_usuario]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if (queryOk) {
        const data = clientOrders[0];

        if (data.length > 0) {
            res.render('employees/employee_show_orders', { data });
        } else {
            req.flash('message', 'No hay órdenes de compra para mostrar');
            res.redirect('/');
        }
    } else {
        req.flash('message', 'Error inesperado en la consulta a la base de datos');
        res.redirect('/');
    }
};

// Ruta para hacer devoluciones
controller.refunds = (req, res) => {
    res.render('employees/employee_refunds');
};

controller.search_order = async (req, res) => {
    const { order } = req.body;

    let response;
    let success = false;

    try {
        response = await connection.query('CALL GET_ORDERBUY_ID(?)', [order]);
        success = true;
    } catch (error) {
        success = false;
    }

    success == true ? res.status(200).send(response[0]) : res.status(500).send([]);
};

controller.makeRefund = async (req, res) => {
    //Variable de control
    let success = false;

    //Recibimiento y organización de los datos
    /* 
        cantidad_di = Cantidad que se quiere devolver
        cantidad_ds = Cantidad comprada del accesorio
    */
    const { order, id_accesorio, cantidad_di, cantidad_ds, defectuoso, precio } = req.body;

    let moneyToRefund = 0;
    let addInventario = 0;

    //Se obtiene el número de devoluciones del accesoio en la orden dada
    let currentRefunds = await connection.query('CALL OBTAIN_CURRENT_REFUNDS(?, ?, ?)', [
        order,
        id_accesorio,
        cantidad_di,
    ]);

    // Si el valor es nulo re reemplaza por un cero
    currentRefunds[0][0].currentRefunds =
        currentRefunds[0][0].currentRefunds == null ? 0 : currentRefunds[0][0].currentRefunds;

    // Se verifica que no se pase el número de accesorios comprados
    if (currentRefunds[0][0].currentRefunds + parseInt(cantidad_di) <= cantidad_ds) {
        if (cantidad_di == defectuoso) {
            //si la cantidad a devolver y los defectuosos es igual, se devuelve dinero pero no retorna a inventario
            moneyToRefund = cantidad_di * precio;
            await connection.query('CALL UPDATE_PROFITS_FROM_REFUNDS(?, ?)', [req.user.id_usuario, moneyToRefund]);
        } else if (defectuoso > 0) {
            //si la cantidad de defectuosos es mayor a uno, se devuelve dinero y se retornan al inventario los que estén bien
            moneyToRefund = cantidad_di * precio;
            addInventario += parseInt(cantidad_di - defectuoso);
            await connection.query('CALL UPDATE_PROFITS_FROM_REFUNDS(?, ?)', [req.user.id_usuario, moneyToRefund]);
            await connection.query('CALL UPDATE_INVENTORY_FROM_REFUNDS(?, ?, ?)', [
                req.user.id_usuario,
                id_accesorio,
                addInventario,
            ]);
        } else if (defectuoso == 0) {
            //si la cantidad de defectuosos es igual a 0, se devuelve el dinero y se retorna todo al inventario
            moneyToRefund = cantidad_di * precio;
            addInventario += parseInt(cantidad_di);
            await connection.query('CALL UPDATE_PROFITS_FROM_REFUNDS(?, ?)', [req.user.id_usuario, moneyToRefund]);
            await connection.query('CALL UPDATE_INVENTORY_FROM_REFUNDS(?, ?, ?)', [
                req.user.id_usuario,
                id_accesorio,
                addInventario,
            ]);
        }

        // En todo caso, se agrega el registro al histórico de devoluciones
        await connection.query('CALL REGISTER_REFUND(?, ?, ?, ?)', [
            order,
            id_accesorio,
            cantidad_di,
            req.user.id_usuario,
        ]);

        success = true;
    }

    if (success) {
        req.flash('success', 'Operación exitosa');
        res.redirect('/employee/refunds');
    } else {
        req.flash('message', 'No fue posible realizar la devolución del accesorio para la orden seleccionada');
        res.redirect('/employee/refunds');
    }
};

module.exports = controller;
