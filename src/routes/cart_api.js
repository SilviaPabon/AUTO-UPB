const express = require('express'); 
const router = express.Router(); 
const protect = require('../libs/protect_middlewares')
const controller = require('../controllers/cart_controller'); 

// -----
// Ruta para agregar elemento al carrito
router.post('/add', protect.isLoggedIn, controller.cartAdd); 

// -----
// Ruta para eliminar elemento del carrito
router.get('/remove/:id', protect.isLoggedIn, controller.cartRemoveGet); 

router.get('/', protect.isLoggedIn,controller.showCart); 

router.post('/update', protect.isLoggedIn,controller.cartUpdate);

router.get('/buy', protect.isLoggedIn, controller.orderClientPost); 

module.exports = router;