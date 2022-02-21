const express = require('express');
const router = express.Router();
const controller = require('../controllers/controller_auth');

router.get('/login', controller.login); 
router.get('/signup', controller.signup); 

module.exports = router;