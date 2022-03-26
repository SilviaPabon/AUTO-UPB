const controller = {};
const connection = require('../database/connection');

controller.orderClient = async (req, res) => {
    res.render('clients/orders_clients');
};

module.exports = controller;