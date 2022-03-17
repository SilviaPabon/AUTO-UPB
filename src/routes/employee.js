const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/employee_controller.js'); 
const protect = require('../libs/protect_middlewares')

//Ruta del carrito para trabajadores
router.get('/cart', protect.isLoggedIn, protect.isWorker,controller.showCart); 
//Ruta para obtener los datos del usuario apartir de su cédula
router.post('/cart/user_exists', protect.isLoggedIn, protect.isWorker, controller.user_exists); 
//Ruta que se encarga de procesar la compra
router.post('/cart/buy', protect.isLoggedIn, protect.isWorker, controller.postOrder); 

module.exports = router;