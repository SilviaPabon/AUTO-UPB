const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const pool = require('../database/connection'); //cambiar la base de datos
const helpers = require('./helpers');

//Signup
passport.use(
    'local.signup',
    new LocalStrategy(
        {
            usernameField: 'email',
            passwordField: 'password',
            passReqToCallback: true,
        },
        async (req, email, password, done) => {
            //Usuario que se va a insertar en la base de datos
            const { name, documento, phone, address, conditions } = req.body;
            const newUser = {
                name,
                documento,
                correo_electronico : email,
                phone,
                address,
                password,
                conditions,
            };
            newUser.conditions = newUser.conditions == 'on' ? 1 : 0;

            //Verificar que el usuario no exista en la base de datos
            const userExist = await pool.query('CALL USER_EXIST(?)', [email]);

            //Si el usuario no existe, se procede con la creación
            if (userExist[0][0]['CONTEO'] == 0) {
                newUser.password = await helpers.encryptPassword(newUser.password);
                await pool.query('CALL REGISTER_NEW_CLIENT(?, ?, ?, ?, ?, ?, ?)', [
                    newUser.name,
                    newUser.documento,
                    newUser.correo_electronico,
                    newUser.address,
                    newUser.phone,
                    newUser.conditions,
                    newUser.password,
                ]);

                return done(null, newUser);
            } else {
                //Si el usuario existe, se manda un flash
                return done(null, false, req.flash('message', `ERROR: El correo: ${newUser.email} ya está en uso.`));
            }
        }
    )
);

//Login
passport.use(
    'local.login',
    new LocalStrategy({
        usernameField: 'email',
        passwordField: 'password',
        passReqToCallback: true,
    },  async (req, email, password, done) => {

        //Comprobar que exista el usuario en la bae de datos
        const userExist = await pool.query('CALL USER_EXIST(?)', [email]);

            //Si el usuario no existe, se procede con la verificación
            if (userExist[0][0]['CONTEO'] == 1) {
                
                const user = await pool.query('CALL GET_USER_SESSION_DATA_FROM_MAIL(?)', [email]);
                const passwordIsValid = await helpers.matchPassword(password, user[0][0].contraseña);

                if(passwordIsValid){
                    done(null, user[0][0]); 
                }else{
                    done(null, false, req.flash('message','ERROR: Contraseña incorrecta.')); 
                }

            }
    })
);

//Serializar el usuario a partir del correo
passport.serializeUser((user, done) => {
    done(null, user.correo_electronico);
});

//Deserializar el usuario a partir del correo
passport.deserializeUser(async (mail, done) => {
    const rows = await pool.query('CALL GET_USER_SESSION_DATA_FROM_MAIL(?)', [mail]);
    done(null, rows[0][0]);
});
