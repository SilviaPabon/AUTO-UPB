const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const pool = require('../database/connection'); //cambiar la base de datos
const helpers = require('./helpers');

// ---------------------------------

// SIGNUP (Sirve tanto para empresas como para personas)
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

            //Si el usuario no existe (a partir del correo), se procede 
            if (userExist[0][0]['CONTEO'] == 0) {

                const userExistDocument = await pool.query('CALL USER_EXIST_FROM_DOCUMENT(?)', [newUser.documento]); 

                //Si el usuario no existe (A partir del documento, se procede)
                if(userExistDocument[0][0]['CONTEO'] == 0){

                    
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

                }else{
                    //Si el usuario existe, se manda un flash
                    return done(null, false, req.flash('message', `ERROR: Ya existe un usuario asociado al documento: ${newUser.documento}`));
                }

            } else {
                //Si el usuario existe, se manda un flash
                return done(null, false, req.flash('message', `ERROR: El correo: ${newUser.correo_electronico} ya está en uso.`));
            }
        }
    )
);

// ---------------------------------
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

            //Si el usuario existe, se procede con la verificación
            if (userExist[0][0]['CONTEO'] == 1) {
                
                //Se traen los datos del usuario desde la base de datos
                const user = await pool.query('CALL GET_USER_SESSION_DATA_FROM_MAIL(?)', [email]);

                //Se verifica que la cuenta se encuentre activa
                if(user[0][0].codigo_estado_cuenta == 1){

                    const userPassword = await pool.query('CALL GET_USER_PASSWORD(?)', [email]); 
                    
                    const passwordIsValid = await helpers.matchPassword(password, userPassword[0][0].contraseña);

                    if(passwordIsValid){
                        done(null, user[0][0]); 
                    }else{
                        done(null, false, req.flash('message','ERROR: Contraseña incorrecta.')); 
                    }


                }else{
                    done(null, false, req.flash('message',`ERROR: El usuario identificado con el correo ${email} no se encuentra activo.`)); 
                }

            }else{
                done(null, false, req.flash('message',`ERROR: No se encontró un usuario con el correo ${email}`)); 
            }
    })
);

// ---------------------------------
//Create Account Admin
passport.use(
    'local.adminSignup',
    new LocalStrategy(
        {
            usernameField: 'email',
            passwordField: 'password',
            passReqToCallback: true,
        },
        async (req, email, password, done) => {
            //Usuario que se va a insertar en la base de datos
            const { name, documento, phone, address, rol } = req.body;
            const newUser = {
                name,
                documento,
                correo_electronico : email,
                phone,
                address,
                password,
                rol,
            };
            newUser.conditions = newUser.conditions == 'on' ? 1 : 0;

            //Verificar que el usuario no exista en la base de datos
            const userExist = await pool.query('CALL USER_EXIST(?)', [email]);

            //Si el usuario no existe, se procede 
            if (userExist[0][0]['CONTEO'] == 0) {

                const userExistDocument = await pool.query('CALL USER_EXIST_FROM_DOCUMENT(?)', [newUser.documento]); 
                //Si el usuario no existe (A partir del documento, se procede)
                if(userExistDocument[0][0]['CONTEO'] == 0){
                    
                    newUser.password = await helpers.encryptPassword(newUser.password);
                    await pool.query('CALL ADMIN_CREATE_ACCOUNT(?, ?, ?, ?, ?, ?, ?, ?)', [
                        req.user.id_usuario,
                        newUser.name,
                        newUser.documento,
                        newUser.correo_electronico,
                        newUser.address,
                        newUser.phone,
                        newUser.password,
                        newUser.rol,
                    ]);

                    req.flash('success', 'Usuario creado exitosamente')
                    return done(null, req.user);
                }else{
                    //Si el usuario existe, se manda un flash
                    return done(null, false, req.flash('message', `ERROR: Ya existe un usuario asociado al documento: ${newUser.documento}`));
                }

            } else {
                //Si el usuario existe, se manda un flash
                return done(null, req.user, req.flash('message', `ERROR: El correo: ${newUser.correo_electronico} ya está en uso.`));
            }
        }
    )
);

// ---------------------------------
//Serializar el usuario a partir del correo
passport.serializeUser((user, done) => {
    done(null, user.correo_electronico);
});

// ---------------------------------
//Deserializar el usuario a partir del correo
passport.deserializeUser(async (correo_electronico, done) => {
    const rows = await pool.query('CALL GET_USER_SESSION_DATA_FROM_MAIL(?)', [correo_electronico]);  
    done(null, rows[0][0]);
});
