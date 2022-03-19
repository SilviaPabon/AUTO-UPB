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

// Ruta para cuando se busca un usuario
controller.searchinventory = async (req, res) => {
    //La ruta solo toma lo que se pasó en el formulario y lo redirige a la vista
    const { criteria } = req.body;
    res.redirect(`/workers/inventory/${criteria}`);
};

// Ruta para mostrar los usuarios resultantes de la búsqueda
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

