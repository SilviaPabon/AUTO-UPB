const controller = {}; 
const pool = require('../database/connection');

controller.accountsPartner = async(req, res) => {
    const users = await pool.query('CALL SHOW_ACCOUNTS_PARTNERS (?)', [req.user.id_usuario]);
    const data = {users, isFiltered : false};
    
    res.render('partner/existing_accounts_partner', {data} );
}

controller.searchAccountsPartner = async (req, res) => {
    // Se toma el criterio de busqueda
    const { criteria } = req.body;
    res.redirect(`/partner/accounts/${criteria}`);
}

controller.searchAccountsResultPartner = async (req, res) => {
    
    const { criteria } = req.params;

    const users = await pool.query('CALL PARTNER_SEARCH_USER_FROM_CRITERIA(?, ?)', [req.user.id_usuario ,criteria]);

    const data = {
        users,
        isFiltered : true,
        criteria
    };

    res.render('partner/existing_accounts_partner', { data });
}

module.exports = controller; 