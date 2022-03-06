module.exports = {
    /*FUNCIÓN PARA VERIFICAR QUE SI ESTÁ LOGUEADO*/
    isLoggedIn(req, res, next) {
        if (req.isAuthenticated()) {
            return next();
        }

        // Si no está logueado se le enía un mensaje informando
        req.flash('message', 'ERROR: Debes iniciar sesión para realizar la acción deseada');
        res.redirect('/login');
    },

    /*FUNCIÓN PARA VERIFICAR QUE NO ESTÉ LOGUEADO*/
    isNotLoggedIn(req, res, next) {
        if (!req.isAuthenticated()) {
            return next();
        }

        // Si está logueado, se envía un mensaje informando
        req.flash('message', 'ERROR: Ya tienes sesión iniciada.');
        res.redirect('/');
    },

    isAdmin(req, res, next) {
        if (req.user.codigo_tipo_usuario == 4) {
            return next();
        }

        //Si no es admin, muestra el aviso y lo redirije al home
        req.flash('message', 'ERROR: No tienes los permisos para realizar esa acción');
        res.redirect('/');
    },

    isPartner(req, res, next) {
        if(req.user.codigo_tipo_usuario == 2){
            return next();
        }

        //Si no es socio, muestra el aviso y lo redirije al home
        req.flash('message', 'ERROR: No tienes los permisos para realizar esa acción');
        res.redirect('/');
    },

    isWorker(req, res, next){
        if(req.user.codigo_tipo_usuario == 3){
            return next();
        }

        //Si no es trabajador, muestra el aviso y lo redirije al home
        req.flash('message', 'ERROR: No tienes los permisos para realizar esa acción');
        res.redirect('/');
    }
};