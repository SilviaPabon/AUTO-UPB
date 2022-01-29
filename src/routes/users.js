
const express = require('express'); 
const router = express.Router(); 

router.get('/', (req, res) => { //Example route
    res.render('index.ejs'); 
});

module.exports = router; 