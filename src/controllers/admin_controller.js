const controller = {}; 
// const pool = require('../database/connection');

controller.createAccount = (req, res) => {
    res.render('auth/create_acc_admin');
};

controller.inventory = (req, res) => {
    res.render('admin/inventory_select_accessory_type');   
}; 

controller.inventory_add_new = (req, res) => {
    res.render('admin/new_accessory');   
}; 

controller.inventory_add_existing = (req, res) => {
    res.render('admin/inventory_select_existing_accessory');   
}; 

// acá hay un pequeño error
controller.inventory_details = (req, res) => {
    res.render('/admin/details');   
}; 

controller.inventory_add_existing_id = (req, res) => {

    const { id } = req.body; 
    console.log(id);

    res.render('admin/existing_accessory');   
}; 

module.exports = controller; 