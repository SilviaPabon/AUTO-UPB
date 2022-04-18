const express = require('express');
const router = express.Router();
const protect = require('../libs/protect_middlewares');
const controller = require('../controllers/cart_controller');

// Ruta para agregar un accesorio al carrito
router.post('/add', protect.isLoggedIn, protect.canUseCart,controller.cartAdd);

// Ruta para eliminar elemento del carrito
router.get('/remove/:id', protect.isLoggedIn, protect.canUseCart,controller.cartRemoveGet);

// Ruta para mostrar el carrtito de compras
router.get('/', protect.isLoggedIn, protect.canUseCart,controller.showCart);

// Ruta para actualizar el número items de un accesorio en el carrito
router.post('/update', protect.isLoggedIn, protect.canUseCart,controller.cartUpdate);

// Ruta para emitir la órden de compra
router.get('/buy', protect.isLoggedIn, protect.canUseCart,controller.orderClientPost);

module.exports = router;
