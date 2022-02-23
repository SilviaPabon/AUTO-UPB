const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/admin_controller');  


router.get('/create_account', controller.createAccount); 


module.exports = router;