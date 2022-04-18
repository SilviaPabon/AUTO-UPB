const express = require('express');
const router = express.Router();
const protect = require('../libs/protect_middlewares');
const controller = require('../controllers/user_controllers');

router.get('/orders', protect.isLoggedIn, controller.orderClient);
router.get('/orderDone/:id', protect.isLoggedIn, protect.ownBuyOrder,controller.orderDone);
router.get('/bill/:id', protect.isLoggedIn, protect.ownBuyOrder,controller.user_bill);

module.exports = router;
