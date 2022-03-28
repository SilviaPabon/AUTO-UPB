const controller = {};
const pool = require('../database/connection');

controller.accountsPartner = async (req, res) => {
    const users = await pool.query('CALL SHOW_ACCOUNTS_PARTNERS (?)', [req.user.id_usuario]);
    const data = { users, isFiltered: false };

    res.render('partner/existing_accounts_partner', { data });
};

controller.searchAccountsPartner = async (req, res) => {
    // Se toma el criterio de busqueda
    const { criteria } = req.body;
    res.redirect(`/partner/accounts/${criteria}`);
};

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
    
        res.render('partner/existing_accounts_partner', { data });
    }else{
        req.flash('message', 'Error: Error inesperado al buscar el usuario con el criterio de búsqueda dado');
        res.redirect('/partner/accounts');
    }
};

controller.inventory = async (req, res) => {
    const inventory = await pool.query('CALL SHOW_ACCESSORIES_INTERNAL(?)', [req.user.id_usuario]);
    const data = {
        ACCESORIOS: inventory[0],
        isFiltered: false,
    };
    res.render('partner/partners_inventory', {
        data,
    });
};

// Ruta para cuando se busca un usuario
controller.searchinventory = async (req, res) => {
    //La ruta solo toma lo que se pasó en el formulario y lo redirige a la vista
    const { criteria } = req.body;
    res.redirect(`/partner/inventory/${criteria}`);
};

// Ruta para mostrar los usuarios resultantes de la búsqueda
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
    
        res.render('partner/partners_inventory', { data });
    }else{
        req.flash('message', 'Error: Algo salió mal al buscar el accesorio con el criterio de búsqueda dado');
        res.redirect('/partner/inventory');
    }
};

module.exports = controller;
