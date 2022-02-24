const controller = {}; 
// const pool = require('../database/connection');

controller.inventory = (req, res) => {
    res.render('admin/inventory_select_accessory_type');   
}; 

controller.inventory_add_new = (req, res) => {
    res.render('admin/new_accessory');   
}; 

module.exports = controller; 