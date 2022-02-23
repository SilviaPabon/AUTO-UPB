const controller = {};

controller.createAccount = (req, res) => {
    res.render('auth/create_acc_admin');
};


module.exports = controller;