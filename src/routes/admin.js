const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/admin_controller');  

router.get('/inventory', controller.inventory); 
router.get('/inventory/add_new', controller.inventory_add_new); 

module.exports = router; 