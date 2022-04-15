const express = require('express'); 
const passport = require('passport');
const router = express.Router(); 
const controller = require('../controllers/admin_controller'); 
const protect = require('../libs/protect_middlewares'); 

// Rutas para creación de cuentas internas
router.get('/create_account', protect.isLoggedIn, protect.isAdmin, controller.createAccount); 
router.post('/create_account', protect.isLoggedIn, protect.isAdmin, passport.authenticate('local.adminSignup', {
    successRedirect: '/',
    failureRedirect: '/admin/create_account',
    failureFlash: true,
}));

// Rutass para modificar el estado de las cuentas existentes
router.get('/account_status/:id', protect.isLoggedIn, protect.isAdmin, controller.state_acc);
router.post('/account_status/:id', protect.isLoggedIn, protect.isAdmin,  controller.state_acc_post);

// Ruta para mostrar al administrador el inventario existente
router.get('/inventory', protect.isLoggedIn, protect.isAdmin, controller.inventory); 

// Ruta para añadir un nuevo accesorio
router.get('/inventory/add_new', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_new); 
router.post('/inventory/add_new', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_new_post);  

// Ruta para mostrar al administrador los accesorios existentes
router.get('/inventory/add_existing', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing);

// Rutas para añadir inventario a un accesorio existente
router.get('/inventory/add_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing_id); 
router.post('/inventory/add_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing_id_post);

// Rutas para permitir al administrador buscar accesorios dentro del inventario 
router.post('/inventory/search_existing',  protect.isLoggedIn, protect.isAdmin,controller.search_inventory_result);
router.get('/inventory/search_existing/:criteria', protect.isLoggedIn, protect.isAdmin, controller.search_inventory_result_get); 

// Rutas para editar accesorios existentes
router.get('/inventory/edit_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_modify);
router.post('/inventory/edit_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_modify_post);  

// Rutas para mostrar al administrador las cuentas existentes
router.get('/accounts', protect.isLoggedIn, protect.isAdmin, controller.accounts); 

// Rutas para permitir al administrador buscar cuentas
router.post('/accounts', protect.isLoggedIn, protect.isAdmin, controller.searchAccounts); 
router.get('/accounts/:criteria', protect.isLoggedIn, protect.isAdmin, controller.searchAccountsResult); 

// Ruta para mostrar al administrador los mensajes de dudas e inquietudes
router.get('/messages', protect.isLoggedIn, protect.isAdmin, controller.messages);

// Rutas del módulo financiero
router.get('/finances', protect.isLoggedIn, protect.isAdmin, controller.finances); 

// Rutas para que el administrador seleccione el accesorio para ver su histórico de precios
router.get('/finances/historical_prices', protect.isLoggedIn, protect.isAdmin, controller.historicalPrices);
router.get('/finances/historical_prices/:id', protect.isLoggedIn, protect.isAdmin, controller.historicalPricesProd);

// Rutas para mostrar al administrador los informes de ingresos, gastos y ganancias/pérdidas
router.get('/finances/perform_details/', protect.isLoggedIn, protect.isAdmin, controller.finantial_perfom_details);
router.get('/finances/perform_details/profits', protect.isLoggedIn, protect.isAdmin, controller.finantial_profits);
router.get('/finances/perform_details/outgoings', protect.isLoggedIn, protect.isAdmin, controller.finantial_outgoings);  

module.exports = router;