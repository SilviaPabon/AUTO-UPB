const express = require('express');
const router = express.Router();
const controller = require('../controllers/general_routes.js');

router.get('/', controller.home); 

module.exports = router;