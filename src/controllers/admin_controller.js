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

controller.inventory_add_new_post = async (req, res) => {

    const {
        name,
        description,
        buyprice,
        sellprice,
        discount,
        inventory,
    } = req.body;
    console.log(req.user.id_usuario);
    const newAcc = {
        usID: req.user.id_usuario,
        name,
        description,
        inventory,
        buyprice,
        sellprice,
        discount,
    };

    //db
    await pool.query('CALL ADD_NEW_ACCESSORY(?, ?, ?, ?, ?, ?, ?)', [
        newAcc.usID,
        newAcc.name,
        newAcc.description,
        newAcc.inventory,
        newAcc.buyprice,
        newAcc.sellprice,
        newAcc.discount,
    ]);

    //
    req.flash('success', 'Transacción: Accesorio Añadido'); 
    res.redirect('/admin/inventory/add_existing');
};

controller.inventory_add_existing = (req, res) => {
    res.render('admin/inventory_select_existing_accessory');   
}; 

controller.inventory_add_existing_id = (req, res) => {

    const { id } = req.body; 
    console.log(id);

    res.render('admin/inventory');   
}; 

module.exports = controller; 