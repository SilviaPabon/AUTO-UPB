const router = {}; 

// Las rutas se separan para mayor organización
router.authentication = require('./router_authentication'); 
router.general = require('./general_routes');
router.admin = require('./admin.js');  

module.exports = router; 