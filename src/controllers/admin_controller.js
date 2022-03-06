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
    const { name, description, buyprice, sellprice, discount, inventory } = req.body;

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

    req.flash('success', 'Transacción exitosa: Accesorio Añadido');
    res.redirect('/admin/inventory/add_existing');
};

controller.inventory_add_existing = async (req, res) => {
    const callAccessories = await pool.query('CALL SHOW_ACCESSORIES()');
    res.render('admin/inventory_select_existing_accessory', { accessories: callAccessories });
};

controller.inventory_add_existing_id = async (req, res) => {
    const { id } = req.params;
    const callAccessories = await pool.query('CALL SHOW_ACCESSORY_DETAILS(?)', [id]);
    res.render('admin/existing_accessory', { accesorios: callAccessories });
};

controller.inventory_add_existing_id_post = async (req, res) => {
    const { id } = req.params;

    const { buyprice, newAmmount } = req.body;

    //Create new plan object
    const addInventory = {
        usID: req.user.id_usuario,
        id,
        buyprice,
        newAmmount,
    };

    //Update it into DB
    await pool.query('CALL ADD_INVENTORY_TO_EXISTING_ACCESSORY(?, ? , ?, ?)', [
        addInventory.usID,
        addInventory.id,
        addInventory.buyprice,
        addInventory.newAmmount,
    ]);

    req.flash('success', 'Transacción exitosa: Accesorio actualizado');
    res.redirect('/admin/inventory/add_existing');
};

// Ruta para mostrar las cuentas existentes
controller.accounts = async (req, res) => {
    const users = await pool.query('CALL ADMIN_SHOW_ACCOUNTS()');

    const data = {
        users,
        isFiltered : false
    };

    res.render('admin/existing_accounts', { data });
};

// Ruta para cuando se busca un usuario
controller.searchAccounts = async (req, res) => {
    //La ruta solo toma lo que se pasó en el formulario y lo redirige a la vista
    const { criteria } = req.body;
    res.redirect(`/admin/accounts/${criteria}`);
};

// Ruta para mostrar los usuarios resultantes de la búsqueda
controller.searchAccountsResult = async (req, res) => {
    const { criteria } = req.params;

    const users = await pool.query('CALL ADMIN_SEARCH_USER_FROM_CRITERIA(?)', [criteria]);

    const data = {
        users,
        isFiltered : true
    };

    res.render('admin/existing_accounts', { data });
};

module.exports = controller;
