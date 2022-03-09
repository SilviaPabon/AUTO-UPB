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

controller.state_acc = async (req, res) => {

    const { id } = req.params;
    const userd = {usID: req.user.id_usuario};

    const user = await pool.query('CALL SHOW_ACCOUNT_DETAILS(?, ?)', [id, userd.usID]);
    const data = {
        user
    }
    res.render('admin/existing_accounts_state', {data});   
}; 

controller.state_acc_post = async (req, res) => {

    const { id } = req.params;

    const { state } = req.body;

    //Create new plan object
    const modifyState = {
        usID: req.user.id_usuario,
        id,
        state,
    };

    await pool.query('CALL CHANGE_EXISTING_USER_STATUS(?, ? , ?)', [
        modifyState.usID,
        modifyState.id,
        modifyState.state
    ]);

    req.flash('success', 'Transacción exitosa: ');
    res.redirect('/admin/accounts')

}

module.exports = controller; 