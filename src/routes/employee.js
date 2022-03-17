const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/employee_controller.js'); 
const protect = require('../libs/protect_middlewares')

router.get('/cart', protect.isLoggedIn, protect.isWorker,controller.showCart); 

module.exports = router;