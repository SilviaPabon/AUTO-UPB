const controller = {};
const pool = require('../database/connection');
const fs = require('fs'); 

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
    let queryOk = false;

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
    try {
        await pool.query('CALL ADD_NEW_ACCESSORY(?, ?, ?, ?, ?, ?, ?)', [
            newAcc.usID,
            newAcc.name,
            newAcc.description,
            newAcc.inventory,
            newAcc.buyprice,
            newAcc.sellprice,
            newAcc.discount,
        ]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if(queryOk){
        req.flash('success', 'Transacción exitosa: Accesorio Añadido');
        res.redirect('/admin/inventory/add_existing');
    }else{
        req.flash('message', 'Error: Algo salió mal al añadir el accesorio');
        res.redirect('/admin/new_accessory');
    }
};

controller.inventory_add_existing = async (req, res) => {
    const callAccessories = await pool.query('CALL SHOW_ACCESSORIES_ADMIN(?)', [req.user.id_usuario]);
    const data = {
        ACCESORIOS: callAccessories,
        isFiltered : false,
    };
    res.render('admin/inventory_select_existing_accessory', { data });
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


controller.search_inventory_result = async (req, res) => {
    const { criteria } = req.body;
    res.redirect(`/admin/inventory/search_existing/${criteria}`);
};

controller.search_inventory_result_get = async (req, res) => {
    const { criteria } = req.params;
    let inventory;
    let queryOk = false;
    try{
        inventory = await pool.query('CALL SEARCH_ACCESSORIES_FROM_CRITERIA_ADMIN(?, ?)', [req.user.id_usuario, criteria]);
        queryOk = true;
    } catch (error) {
        req.flash('message', 'Ocurrió un error inesperado al buscar el accesorio.'); 
        queryOk = false;
    }
    if(queryOk){
        const data = {
            ACCESORIOS: inventory,
            isFiltered : true,
            criteria
        };
    
        res.render('admin/inventory_select_existing_accessory', { data });
    }
    else{
        res.redirect('/admin/inventory/add_existing')
    }
    
};



controller.inventory_modify = async (req, res) => {
    const { id } = req.params;
    const callAccessories = await pool.query('CALL SHOW_ACCESSORY_DETAILS_ADMIN(?)', [id]);
    res.render('admin/existing_accesory_modify', { accesorios: callAccessories });
}

controller.inventory_modify_post = async (req, res) => {

    const { id } = req.params;
    const { name, originalName, description, status_select, price, discount, originalImageRoute } = req.body;

    // Hace la nueva ruta de la ímagen según el nuevo nombre ingresado
    const newImageRoute = `/${name.replace(/\s/g, '_')}.jpg`; 

    if(newImageRoute != originalImageRoute){
        fs.rename(`${req.app.settings.static}\\images${originalImageRoute}`, `${req.app.settings.static}\\images${newImageRoute}`, function(err){
            if(err){
                //Just for handle the error
            }
        })
    }
    
    //Create new plan object
    const updInventory = {
        usID: req.user.id_usuario,
        id,
        status_select,
        name,
        description,
        price,
        discount,
    };

    //Update it into DB
    const accessoryExist = await pool.query('CALL ACCESSORY_EXIST(?)',[name]);
    if(accessoryExist[0][0]['CONTEO'] == 0 || (accessoryExist[0][0]['CONTEO'] == 1 && name == originalName)) {

        //Update it into DB
        await pool.query('CALL UPDATE_EXISTING_ACCESSORY(?, ?, ?, ?, ?, ?, ?)', [
            updInventory.usID,
            updInventory.id,
            updInventory.status_select,
            updInventory.name,
            updInventory.description,
            updInventory.price,
            updInventory.discount
        ]);
        req.flash('success', 'Transacción exitosa: Accesorio actualizado');
        res.redirect('/admin/inventory/add_existing');

    }else{
        req.flash('message','Transacción fallida: El accesorio '+name+' ya existe');
        res.redirect(`/admin/inventory/edit_existing/${id}`);
    }
}

// Ruta para mostrar las cuentas existentes
controller.accounts = async (req, res) => {
    const users = await pool.query('CALL ADMIN_SHOW_ACCOUNTS(?)', [req.user.id_usuario]);

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

    const users = await pool.query('CALL ADMIN_SEARCH_USER_FROM_CRITERIA(?, ?)', [req.user.id_usuario ,criteria]);

    const data = {
        users,
        isFiltered : true,
        criteria
    };

    res.render('admin/existing_accounts', { data });
};


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

controller.messages = async (req, res) => {
    const data = await pool.query('CALL GETALL_MESSAGES(?)', [req.user.id_usuario]);
    res.render('admin/show_messages', {data});
}

controller.finances = (req, res) => {
    res.render('admin/finances_select_option');
};

controller.historicalPrices = async (req, res) => {
    const callAccessories = await pool.query('CALL SHOW_ACCESSORIES_ADMIN(?)', [req.user.id_usuario]);
    res.render('admin/finances_products', { accesorios: callAccessories });
};

controller.historicalPricesProd = async (req, res) => {
    const { id } = req.params;
    const callAccessories = await pool.query('CALL HISTORICAL_ACCESSORY_PRICES(?, ?)', [req.user.id_usuario, id]);
    res.render('admin/finances_historic_prices', { accesorios: callAccessories });
};

controller.finantial_perfom_details = (req, res) => {
    res.render('admin/finances_perform_details');
};

module.exports = controller; 

