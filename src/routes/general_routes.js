const express = require('express');
const router = express.Router();
const controller = require('../controllers/general_routes.js');
const protect = require('../libs/protect_middlewares');

// Ruta del home
router.get('/', controller.home);

// Ruta para mostrar los accesorios vendidos
router.get('/accessories', controller.accessories);

// Ruta para ver los detalles de un accesorio
router.get('/accessories/:id', controller.accessoryDetails);

// Rutas para actualización de cuenta
router.get('/update', protect.isLoggedIn, controller.userUpdate);
router.post('/update', protect.isLoggedIn, controller.userUpdate_post);

// Ruta para que los usuarios puedan desactivar sus cuentas
router.get('/deactivate', protect.isLoggedIn, controller.userDeactivate);

// Rutas del formulario de contacto
router.get('/contact_us', controller.contactUs);
router.post('/contact_us', controller.contactUspost);

module.exports = router;
