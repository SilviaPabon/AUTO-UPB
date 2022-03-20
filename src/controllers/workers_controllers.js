const controller = {};
const pool = require('../database/connection');

controller.inventory=async(req,res)=>{
    const inventory = await pool.query('CALL SHOW_ACCESSORIES_INTERNAL(?)', [req.user.id_usuario]);
    const data = {
        ACCESORIOS: inventory[0],
        isFiltered:false
    }
    res.render('workers/existing_inventory', {
        data
    });
}


controller.searchinventory = async (req, res) => {
    //se toma como "criteria" la busqueda que se haga desde la barra de navegacion
    const { criteria } = req.body;
    res.redirect(`/workers/inventory/${criteria}`);
};

// Se hace el llamado al proceso de la base de datos para la barra de busqueda
controller.searchinventoryResult = async (req, res) => {
    const { criteria } = req.params;

    const inventory = await pool.query('CALL SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL(?, ?)', [req.user.id_usuario, criteria]);

    const data = {
        ACCESORIOS: inventory[0],
        isFiltered : true,
        criteria
    };

    res.render('workers/existing_inventory', { data });
};

module.exports = controller; 

