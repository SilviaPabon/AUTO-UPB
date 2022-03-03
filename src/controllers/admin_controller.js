const controller = {}; 
const pool = require('../database/connection');

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

controller.inventory_add_existing_id = (req, res) => {

    const { id } = req.body; 

    res.render('admin/existing_accessory');   
}; 

controller.accounts = async (req, res) => {

    const users = await pool.query('CALL ADMIN_SHOW_ACCOUNTS()');
    
    const data = {
        users
    }

    res.render('admin/existing_accounts', {data}); 
}

module.exports = controller; 