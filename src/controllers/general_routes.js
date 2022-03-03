const controller = {}; 
const pool = require('../database/connection');

controller.home = async(req, res) => {

    // Se obtienen los productos en descuento
    const disccountProducts = await pool.query('CALL SHOW_TOP_DISCOUNT()'); 

    // Se obtienen los productos top más vendidos
    const featuredProducts = await pool.query('CALL SHOW_TOP_SALES()'); 

    console.log(featuredProducts); 
    console.log(featuredProducts[0][0]['nombre']); 

    const data = {
        disccountProducts, 
        featuredProducts
    }
    
    res.render('index', {data}); 
}; 

controller.accessories = (req, res) => {
    res.render('products'); 
}

module.exports = controller; 