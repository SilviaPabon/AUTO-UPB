const express = require('express'); 
const router = express.Router(); 
const controller = require('../controllers/partner_controller'); 
const protect = require('../libs/protect_middlewares'); 

router.get('/accounts', protect.isLoggedIn, protect.isPartner, controller.accountsPartner);  

router.post('/accounts/', protect.isLoggedIn, protect.isPartner, controller.searchAccountsPartner, );

router.get('/accounts/:criteria', protect.isLoggedIn, protect.isPartner, controller.searchAccountsResultPartner);


router.get('/inventory', protect.isLoggedIn, protect.isPartner, controller.inventory);
router.post('/inventory', protect.isLoggedIn, protect.isPartner,controller.searchinventory); 
router.get('/inventory/:criteria',  protect.isLoggedIn, protect.isPartner,controller.searchinventoryResult);


module.exports = router;