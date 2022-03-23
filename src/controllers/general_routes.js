const controller = {};
const pool = require('../database/connection');
const helpers = require('../libs/helpers');

controller.home = async (req, res) => {
    // Se obtienen los productos en descuento
    const disccountProducts = await pool.query('CALL SHOW_TOP_DISCOUNT()');

    // Se obtienen los productos top más vendidos
    const featuredProducts = await pool.query('CALL SHOW_TOP_SALES()');

    const data = {
        disccountProducts,
        featuredProducts,
    };
    
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
    
    const userd = await pool.query('CALL GET_USER_DATA_FROM_ID (?)',[req.user.id_usuario])
    res.render('userUpdate', { userd }); 
}
controller.userUpdate_post = async (req, res) => {
    const {email, phone, address, password} = req.body;
    const encPassword = await helpers.encryptPassword(password);
    const emailExist = await pool.query('CALL USER_EXIST(?)',[email]);
    if(emailExist[0][0]['CONTEO'] == 0 || (emailExist[0][0]['CONTEO'] = 1 && req.user.correo_electronico == email) ) {

        await pool.query('CALL UPDATE_EXISTING_USER(?,?,?,?,?,?)',
        [
            req.user.id_usuario,
            req.user.id_usuario,
            email,
            address,
            phone,
            encPassword
        ]);
        req.flash('success','Datos actualizados exitosamente');
        req.user;
        res.redirect('/');

    }else{
        req.user;
        req.flash('message','El correo '+email+' ya está en uso');
        res.redirect('/update');
    }
}

controller.contactUs = async (req, res) =>{
    res.render('contact_us');
}

module.exports = controller;
