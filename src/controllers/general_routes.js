const controller = {}; 

controller.home = (req, res) => {
    console.log(req.user); 
    res.send(req.user);
}; 

module.exports = controller; 