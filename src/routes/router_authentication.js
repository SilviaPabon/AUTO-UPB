const express = require('express');
const passport = require('passport');
const router = express.Router();
const controller = require('../controllers/controller_auth');

router.get('/login', controller.login); 
router.post('/login', passport.authenticate('local.login', {
    successRedirect: '/',
    failureRedirect: '/login',
    failureFlash: true, 
    successFlash: true, 
})); 

router.get('/signup', controller.signup); 
router.post('/signup',  passport.authenticate('local.signup', {
    successRedirect: '/',
    failureRedirect: '/signup',
    failureFlash: true,
    successFlash: true, 
})); 

module.exports = router;