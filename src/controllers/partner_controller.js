const controller = {};
const pool = require('../database/connection');

// Controlador de la ruta para mostrar las cuentas existentes
controller.accountsPartner = async (req, res) => {
    const users = await pool.query('CALL SHOW_ACCOUNTS_PARTNERS (?)', [req.user.id_usuario]);
    const data = { users, isFiltered: false };

    res.render('partner/partners_show_accounts', { data });
};

// Controlador de la ruta para realizar búsquedas de clientes
controller.searchAccountsPartner = async (req, res) => {
    // Se toma el criterio de busqueda
    const { criteria } = req.body;
    res.redirect(`/partner/accounts/${criteria}`);
};

// Controlador de la ruta para mostrar el resultado de la búsqueda de clientes
controller.searchAccountsResultPartner = async (req, res) => {
    const { criteria } = req.params;
    let queryOk = false; 

    try {
        var users = await pool.query('CALL PARTNER_SEARCH_USER_FROM_CRITERIA(?, ?)', [req.user.id_usuario, criteria]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if(queryOk) {
        const data = {
            users,
            isFiltered: true,
            criteria,
        };
    
        res.render('partner/partners_show_accounts', { data });
    }else{
        req.flash('message', 'Error: Error inesperado al buscar el usuario con el criterio de búsqueda dado');
        res.redirect('/partner/accounts');
    }
};

// Controlador de la ruta para mostrar el inventario
controller.inventory = async (req, res) => {
    const inventory = await pool.query('CALL SHOW_ACCESSORIES_INTERNAL(?)', [req.user.id_usuario]);
    const data = {
        ACCESORIOS: inventory[0],
        isFiltered: false,
    };
    res.render('partner/partners_show_inventory', {
        data,
    });
};

// Controlador de la ruta para buscar un accesorio en el inventario
controller.searchinventory = async (req, res) => {
    //La ruta solo toma lo que se pasó en el formulario y lo redirige a la vista
    const { criteria } = req.body;
    res.redirect(`/partner/inventory/${criteria}`);
};

// Controlador de la ruta para mostrar el resultado de la búsqueda de accesorios
controller.searchinventoryResult = async (req, res) => {
    const { criteria } = req.params;
    let queryOk = false;

    try {
        var inventory = await pool.query('CALL SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL(?, ?)', [
            req.user.id_usuario,
            criteria,
        ]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if(queryOk) {
        const data = {
            ACCESORIOS: inventory[0],
            isFiltered: true,
            criteria,
        };
    
        res.render('partner/partners_show_inventory', { data });
    }else{
        req.flash('message', 'Error: Algo salió mal al buscar el accesorio con el criterio de búsqueda dado');
        res.redirect('/partner/inventory');
    }
};

module.exports = controller;
