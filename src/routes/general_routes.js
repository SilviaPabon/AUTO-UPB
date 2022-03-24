const express = require('express');
const router = express.Router();
const controller = require('../controllers/general_routes.js');
const protect = require('../libs/protect_middlewares');

router.get('/', controller.home); 
router.get('/accessories', controller.accessories)
router.get('/accessories/:id', controller.accessoryDetails); 
router.get('/update', protect.isLoggedIn, controller.userUpdate);
router.post('/update', protect.isLoggedIn, controller.userUpdate_post);
router.get('/contact_us',controller.contactUs);
router.post('/contact_us', controller.contactUspost);

module.exports = router;