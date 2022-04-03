const express = require('express'); 
const path = require('path');
const morgan = require('morgan'); 
const flash = require('connect-flash');
const session = require('express-session'); 
const MySQLStore = require('express-mysql-session')(session); 

//Requiere passport e inicializa la cofiguración
const passport = require('passport');
require('./libs/passport'); 

/*
Conexión para guardar las sesiones en la base de datos
La expiración de la sesión es de medio día y se revisa la tabla 
En busca de sesiones expiradas cada 30 minutos 
*/
const sessionStore = new MySQLStore({
    host: process.env.PRINCIPAL_DB_HOST, 
    database: process.env.PRINCIPAL_DB_NAME, 
    user: process.env.PRINCIPAL_DB_USER, 
    port: process.env.PRINCIPAL_DB_PORT, 
    password: process.env.PRINCIPAL_DB_PASSWORD, 
    clearExpired: true, 
    checkExpirationInterval: 1800000, 
    expiration: 43200000, 
    createDatabaseTable: true
}); 

const app = express(); 

// -- Settings --
app.set('port', process.env.PORT || 3000); 
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.set('static', path.join(__dirname, 'public')); 

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
    saveUninitialized: false,
    cookie: {
        maxAge: 43200000
    },
    store: sessionStore
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
        
    next();
});

// -- Routes --
const router = require('./routes/router.js'); 
app.use('/', router.authentication); 
app.use('/', router.general); 
app.use('/admin', router.admin); 
app.use('/employee', router.employee)
app.use('/cart', router.cart); 
app.use('/partner', router.partner);
app.use('/user', router.user);  

// -- Starting the server --
app.listen(app.get('port'), ()=> {
    console.log(`Server listening on port ${app.get('port')}`);
}); 