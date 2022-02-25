const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/admin_controller');  
const passport = require('passport');

router.get('/create_account', controller.createAccount); 
router.post('/create_account',  passport.authenticate('local.adminSignup', {
    successRedirect: '/',
    failureRedirect: '/create_account',
    failureFlash: true,
})); 

module.exports = router;