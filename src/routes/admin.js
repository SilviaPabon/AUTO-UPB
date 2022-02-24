const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/admin_controller');  

router.get('/inventory', controller.inventory); 

module.exports = router; 