const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/employee_controller.js'); 
const protect = require('../libs/protect_middlewares')

router.get('/cart', protect.isLoggedIn, protect.isWorker,controller.showCart); 
router.post('/cart/buy', protect.isLoggedIn, protect.isWorker, controller.postOrder); 

module.exports = router;