const express = require('express'); 
const passport = require('passport');
const router = express.Router(); 
const controller = require('../controllers/admin_controller'); 
const protect = require('../libs/protect_middlewares')

router.get('/create_account', protect.isLoggedIn, protect.isAdmin, controller.createAccount); 
router.post('/create_account', protect.isLoggedIn, protect.isAdmin, passport.authenticate('local.adminSignup', {
    successRedirect: '/',
    failureRedirect: '/admin/create_account',
    failureFlash: true,
}));
router.get('/account_status/:id', protect.isLoggedIn, protect.isAdmin, controller.state_acc);
router.post('/account_status/:id', protect.isLoggedIn, protect.isAdmin,  controller.state_acc_post);

router.get('/inventory', protect.isLoggedIn, protect.isAdmin, controller.inventory); 
router.get('/inventory/add_new', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_new); 
router.post('/inventory/add_new', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_new_post);  
router.get('/inventory/add_existing', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing);
router.get('/inventory/add_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing_id); 
router.post('/inventory/add_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_add_existing_id_post);

router.post('/inventory/search_existing',  protect.isLoggedIn, protect.isAdmin,controller.search_inventory_result);
router.get('/inventory/search_existing/:criteria', protect.isLoggedIn, protect.isAdmin, controller.search_inventory_result_get); 


router.get('/inventory/edit_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_modify);
router.post('/inventory/edit_existing/:id', protect.isLoggedIn, protect.isAdmin, controller.inventory_modify_post);  

router.get('/accounts', protect.isLoggedIn, protect.isAdmin, controller.accounts); 
router.post('/accounts', protect.isLoggedIn, protect.isAdmin, controller.searchAccounts); 
router.get('/accounts/:criteria', protect.isLoggedIn, protect.isAdmin, controller.searchAccountsResult)

router.get('/messages', protect.isLoggedIn, protect.isAdmin, controller.messages);

router.get('/finances', protect.isLoggedIn, protect.isAdmin, controller.finances); 
router.get('/finances/historical_prices', protect.isLoggedIn, protect.isAdmin, controller.historicalPrices);
router.get('/finances/historical_prices/:id', protect.isLoggedIn, protect.isAdmin, controller.historicalPricesProd);
router.get('/finances/perform_details/', protect.isLoggedIn, protect.isAdmin, controller.finantial_perfom_details); 

module.exports = router;