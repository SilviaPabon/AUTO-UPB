const controller = {};
const pool = require('../database/connection');

controller.home = async (req, res) => {
    // Se obtienen los productos en descuento
    const disccountProducts = await pool.query('CALL SHOW_TOP_DISCOUNT()');

    // Se obtienen los productos top más vendidos
    const featuredProducts = await pool.query('CALL SHOW_TOP_SALES()');

    const data = {
        disccountProducts,
        featuredProducts,
    };

    console.table(req.session.cart); 
    
    res.render('index', {data}); 
}; 

controller.accessories = async (req, res) => {
    const products = await pool.query('CALL SHOW_ACCESSORIES');
    res.render('products', { products });
};

controller.accessoryDetails = async (req, res) => {
    const { id } = req.params;

    const product = await pool.query('CALL SHOW_ACCESSORY_DETAILS(?)', [id]);

    if(product[0].length != 0){
        res.render('productDetails', { product }); 
    }else{
        req.flash('message', 'ERROR: No se encontró el accesorio solicitado'); 
        res.redirect('/'); 
    }

};

controller.userUpdate = async (req, res) => {
    
    res.render('userUpdate'); //poner la consulta del usuario actual
}

module.exports = controller;
