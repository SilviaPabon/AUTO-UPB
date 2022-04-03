const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/employee_controller.js'); 
const protect = require('../libs/protect_middlewares')

//Ruta del carrito para trabajadores
router.get('/cart', protect.isLoggedIn, protect.isWorker,controller.showCart); 
//Ruta para eliminar un accesorio del carrito
router.get('/cart/remove/:id', protect.isLoggedIn, protect.isWorker, controller.cartRemoveGet)
//Ruta para obtener los datos del usuario apartir de su cédula
router.post('/cart/user_exists', protect.isLoggedIn, protect.isWorker, controller.user_exists); 
//Ruta que se encarga de procesar la compra
router.post('/cart/buy', protect.isLoggedIn, protect.isWorker, controller.postOrder); 
//Ruta para mostrar al trabajador el inventario existente
router.get('/inventory', protect.isLoggedIn, protect.isWorker, controller.inventory);
//Ruta post para que el trabajador busque accesorios en el inventario
router.post('/inventory', protect.isLoggedIn, protect.isWorker,controller.searchinventory);
//Ruta para mostrar al trabajador los accesoriso que compran con el criterio de búsqueda. 
router.get('/inventory/:criteria',  protect.isLoggedIn, protect.isWorker,controller.searchinventoryResult);

//Ruta para mostrar al trabajador orden de compra. 
router.get('/refunds',  protect.isLoggedIn, protect.isWorker, controller.refunds);
//Ruta para enviar la información para hacer la devolución
router.post('/refunds',  protect.isLoggedIn, protect.isWorker, controller.makeRefund);
//Ruta para traer la información de la orden de compra
router.post('/refunds/search_order',  protect.isLoggedIn, protect.isWorker, controller.search_order);

//Ruta para mostrar al trabajador las ordenes de compra de los clientes.
router.get('/orders', protect.isLoggedIn, protect.isWorker,controller.showorders);

module.exports = router;