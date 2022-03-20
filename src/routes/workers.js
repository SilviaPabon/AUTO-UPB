const express = require('express'); 
const protect = require('../libs/protect_middlewares')
const router = express.Router(); 
const controller = require('../controllers/workers_controllers'); 


router.get('/inventory', protect.isLoggedIn, protect.isWorker, controller.inventory);
router.post('/inventory', protect.isLoggedIn, protect.isWorker,controller.searchinventory); 
router.get('/inventory/:criteria',  protect.isLoggedIn, protect.isWorker,controller.searchinventoryResult);

module.exports = router;