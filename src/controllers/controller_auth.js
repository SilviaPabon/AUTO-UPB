const controller = {}; 
// const pool = require('../database/connection');

controller.signup = (req, res) => {
    res.render('auth/signup');  
}; 

controller.login = (req, res) => {
    res.render('auth/login'); 
}; 

module.exports = controller; 