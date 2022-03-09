const express = require('express'); 
const router = express.Router(); 
const protect = require('../libs/protect_middlewares')
const connection = require('../database/connection'); 
const controller = require('../controllers/cart_controller'); 

router.post('/add', protect.isLoggedIn, controller.cartAdd); 


module.exports = router;