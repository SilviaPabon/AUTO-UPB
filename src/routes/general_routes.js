const express = require('express');
const router = express.Router();
const controller = require('../controllers/general_routes.js');

router.get('/', controller.home); 
router.get('/accessories', controller.accessories)

module.exports = router;