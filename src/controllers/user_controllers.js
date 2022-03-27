const controller = {};
const pool = require('../database/connection');

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

        if(data.length > 0) {
            res.render('clients/orders_clients', {data});
        }else{
            req.flash('message', 'No hay órdenes de compra para mostrar');
            res.redirect('/');
        }

    } else {
        req.flash('message', 'Error inesperado en la consulta a la base de datos');
        res.redirect('/');
    }
};

module.exports = controller;
