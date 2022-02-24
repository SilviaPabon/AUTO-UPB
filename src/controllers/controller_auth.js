const controller = {}; 
// const pool = require('../database/connection');

controller.signup = (req, res) => {
    res.render('auth/signup');  
}; 

controller.login = (req, res) => {
    res.render('auth/login'); 
}; 

controller.logout = (req, res) => {
    req.logOut(); //Cierra la sesión
    res.redirect('/login'); //Lo redirecciona a iniciar sesión
}

module.exports = controller; 