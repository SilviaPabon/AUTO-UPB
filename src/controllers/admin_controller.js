const controller = {}; 
// const pool = require('../database/connection');

controller.inventory = (req, res) => {
    res.render('admin/inventory_select_accessory_type');   
}; 


module.exports = controller; 