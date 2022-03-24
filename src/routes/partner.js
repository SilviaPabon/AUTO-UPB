const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/partner_controller'); 
const protect = require('../libs/protect_middlewares'); 

router.get('/accounts', protect.isLoggedIn, protect.isPartner, controller.accountsPartner);  

router.post('/accounts/', protect.isLoggedIn, protect.isPartner, controller.searchAccountsPartner, );

router.get('/accounts/:criteria', protect.isLoggedIn, protect.isPartner, controller.searchAccountsResultPartner);



module.exports = router;