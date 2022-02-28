const controller = {}; 

controller.home = (req, res) => {
    res.render('index'); 
}; 

controller.accessories = (req, res) => {
    res.render('products'); 
}

module.exports = controller; 