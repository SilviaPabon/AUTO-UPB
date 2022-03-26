const express = require('express'); 
const router = express.Router(); 
const protect = require('../libs/protect_middlewares')
const controller = require('../controllers/user_controllers'); 

router.get('/orders', protect.isLoggedIn, controller.orderClient);

module.exports = router;

