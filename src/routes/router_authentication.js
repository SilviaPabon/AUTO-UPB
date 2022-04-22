const express = require('express');
const passport = require('passport');
const router = express.Router();
const controller = require('../controllers/controller_auth');
const protect = require('../libs/protect_middlewares');

router.get('/login', protect.isNotLoggedIn, controller.login);
router.post(
    '/login',
    protect.isNotLoggedIn,
    passport.authenticate('local.login', {
        successRedirect: '/',
        failureRedirect: '/login',
        failureFlash: true,
    })
);

router.get('/signup', protect.isNotLoggedIn, controller.signup);
router.post(
    '/signup',
    protect.isNotLoggedIn,
    passport.authenticate('local.signup', {
        successRedirect: '/',
        failureRedirect: '/signup',
        failureFlash: true,
    })
);

// Ruta para el registro de empresas
router.get('/signupBusiness', protect.isNotLoggedIn, controller.businessSignup);

router.get('/logout', protect.isLoggedIn, controller.logout);

module.exports = router;
