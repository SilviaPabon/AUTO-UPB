const controller = {}; 

controller.home = (req, res) => {
    res.send(req.user);
}; 

module.exports = controller; 