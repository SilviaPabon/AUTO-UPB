const express = require('express'); 
const passport = require('passport');
const router = express.Router(); 
const controller = require('../controllers/admin_controller'); 

router.get('/create_account', controller.createAccount); 
router.post('/create_account',  passport.authenticate('local.adminSignup', {
    successRedirect: '/',
    failureRedirect: '/admin/create_account',
    failureFlash: true,
}));

router.get('/inventory', controller.inventory); 
router.get('/inventory/add_new', controller.inventory_add_new); 
router.get('/inventory/add_existing', controller.inventory_add_existing); 
router.get('/inventory/add_existing/:id', controller.inventory_add_existing_id);  

module.exports = router;