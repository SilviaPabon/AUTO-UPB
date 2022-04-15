const express = require('express');
const router = express.Router();
const controller = require('../controllers/partner_controller');
const protect = require('../libs/protect_middlewares');

// Ruta pra mostrar al socio las cuentas existentes
router.get('/accounts', protect.isLoggedIn, protect.isPartner, controller.accountsPartner);

// Rutas para permitir al socio buscar cuentas de usuario
router.post('/accounts/', protect.isLoggedIn, protect.isPartner, controller.searchAccountsPartner);
router.get('/accounts/:criteria', protect.isLoggedIn, protect.isPartner, controller.searchAccountsResultPartner);

// Ruta para mostrar al socio el inventario
router.get('/inventory', protect.isLoggedIn, protect.isPartner, controller.inventory);

// Rutas para permitir al socio buscar accesorios en el inventario
router.post('/inventory', protect.isLoggedIn, protect.isPartner, controller.searchinventory);
router.get('/inventory/:criteria', protect.isLoggedIn, protect.isPartner, controller.searchinventoryResult);

module.exports = router;
