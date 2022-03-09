const express = require('express'); 
const path = require('path');
const morgan = require('morgan'); 
const flash = require('connect-flash');
const session = require('express-session'); 

//Requiere passport e inicializa la cofiguración
const passport = require('passport');
require('./libs/passport'); 


const app = express(); 

// -- Settings --
app.set('port', process.env.PORT || 3000); 
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// -- Static files route --
app.use(express.static(path.join(__dirname, 'public')));

// -- Middlewares --
app.use(morgan('dev')); 
app.use(
    express.urlencoded({
        extended: false,
    })
);
app.use(express.json());

// -- Sesión de la aplicación
app.use(session({
    secret: process.env.SECRET,
    resave: false,
    saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session());

//Flash para enviar mensajes de errores o success
app.use(flash());

// -- Global variables --
app.use((req, res, next) => {
    app.locals.success = req.flash('success'); 
    app.locals.message = req.flash('message');
    app.locals.user = req.user;
    
    if(!req.session.cart){
        req.session.cart = []; 
    }
    
    next();
});

// -- Routes --
const router = require('./routes/router.js'); 
app.use('/', router.authentication); 
app.use('/', router.general); 
app.use('/admin', router.admin); 
app.use('/cart', router.cart); 

// -- Starting the server --
app.listen(app.get('port'), ()=> {
    console.log(`Server listening on port ${app.get('port')}`);
}); 