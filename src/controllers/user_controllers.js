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
        console.log(req.user.id_usuario); 

        res.render('clients/orders_clients', {data});
    } else {
        req.flash('error', 'Error inesperado en la consulta a la base de datos');
        res.redirect('/');
    }
};

module.exports = controller;
