const controller = {};
const pool = require('../database/connection');

// ----------------------------------------------------------------
//Controlador para que el cliente pueda ver sus órdenes de compra
controller.orderClient = async (req, res) => {
    let queryOk = false;

    try {
        var clientOrders = await pool.query('CALL GET_USER_ORDERBUY_FROM_ID(?)', [req.user.id_usuario]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if (queryOk) {
        const data = clientOrders[0];

        if (data.length > 0) {
            res.render('clients/orders_clients', { data });
        } else {
            req.flash('message', 'No hay órdenes de compra para mostrar');
            res.redirect('/');
        }
    } else {
        req.flash('message', 'Error inesperado en la consulta a la base de datos');
        res.redirect('/');
    }
};

// ----------------------------------------------------------------
//Controlador para que el cliente pueda ver sus órdenes de compra



//para que el cliente confirme el "entregado" de la compra

controller.orderDone = async (req, res) => {
    
    await pool.query('CALL MARK_ORDER_AS_RECEIVED(?,?)', [req.user.id_usuario, req.params.id]);

    res.redirect('/user/orders');

};

// ----------------------------------------------------------------
// Controlador para mostrar la factura de la compra del cliente
controller.user_bill = async (req, res) => {
    let queryOk = false;
    const date = new Date();

    //Obtención de los datos de la factura
    try {
        var billDetails = await pool.query('CALL get_bill_details_from_id(?, ?)', [req.user.id_usuario, req.params.id]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    const data = {
        id_factura: billDetails[0][0].id_factura,
        id_orden: billDetails[0][0].id_orden,
        fecha_compra: billDetails[0][0].fecha_compra,
        fecha_emision: date.toLocaleDateString(),
        nombre_cliente: billDetails[0][0]['Nombre cliente'],
        total_base: billDetails[0][0]['Total Precios Base'], 
        total_descuentos: billDetails[0][0]['Descuentos aplicados'], 
        total_impuestos: billDetails[0][0]['IVA aplicado'], 
        total: billDetails[0][0].Total,
        productos: JSON.parse(billDetails[0][0].productos),
    };

    if (queryOk) {
        res.render('shop/bill.ejs', { data: data });
    } else {
        req.flash('message', 'Error en la consulta de la factura');
        res.redirect('/user/orders');
    }
};

module.exports = controller;
