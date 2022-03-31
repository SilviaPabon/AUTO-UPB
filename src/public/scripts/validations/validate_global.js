// Expresiones regulares para todos los inputs
const regEx = {
    contact: {
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        name: /^[a-zA-ZÀ-ÿ\s]{5,65}$/,
        message: /^.{10,324}$/,
    }, // Expresiones regulares para el formulario de contacto

    inventory_add: {
        name: /^.{3,64}$/, //15 a 64 caracteres
        description: /^.{10,324}$/, //15 a 64 caracteres
        buyprice: /^\d{2,12}$/,
        sellprice: /^\d{2,12}$/,
        inventory: /^\d{1,4}$/,
        discount: /^\d{1,3}$/,
    }, // Expresiones regulares para añadir un nuevo accesorio al Inventario

    inventory_update: {
        name: /^.{3,64}$/,
        description: /^.{10,324}$/,
        price: /^\d{2,12}$/,
        discount: /^\d{1,3}$/,
    }, // Expresiones regulares para modificar un accesorio del Inventario

    inventory_add_units: {
        buyprice: /^\d{2,12}$/,
        newAmmount: /^\d{1,4}$/,
    },

    login: {
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
    }, // Expresiones regulares para validar el formulario de inicio de sesión

    signup_admin: {
        name: /^[a-zA-ZÀ-ÿ\s]{5,40}$/, //Solo se permiten, letras, espacios y acentos
        documento: /^\d{6,14}$/, // 6 a 14 numeros.
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
        phone: /^\d{7,10}$/, // 7 a 10 numeros.
        address: /^.{15,100}$/, //15 a 100 caracteres
    }, // Expresiones regulares para validar el formulario de creación de cuenta de administradores

    signup_user: {
        name: /^[a-zA-ZÀ-ÿ\s]{5,40}$/, //Solo se permiten, letras, espacios y acentos
        documento: /^\d{6,14}$/, // 6 a 14 numeros.
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
        phone: /^\d{7,10}$/, // 7 a 10 numeros.
        address: /^.{15,100}$/, //Ce 15 a 100 caracteres
    }, // Expresiones regulares para validar el formulario de creación de cuenta de usuarios

    signup_business: {
        name: /^.{5,85}$/, //Contiene 2 a 100 caracteres
        documento: new RegExp('^[0-9]{9}(-[0-9]{1})$'), // Formato del NIT
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
        phone: /^\d{7,10}$/, // 7 a 10 numeros.
        address: /^.{15,100}$/, //Ce 15 a 100 caracteres
    }, // Expresiones regulares para validar el formulario de creación de cuenta para empresas de

    account_status: {}, // Expresiones regulares para validar la modificación del estado de la cuenta de usuarios

    account_update: {
        email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
        password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
        phone: /^\d{7,10}$/, // 7 a 10 numeros.
        address: /^.{15,100}$/, //Ce 15 a 100 caracteres
    },
};

// ----------------------------------------------------------------
// Objeto de control para el estado de las validacioens
const fields = {
    contact: {
        name: false,
        email: false,
        message: false,
    }, //Control de estado para los inputs del formulario de contacto

    inventory_add: {
        name: false,
        description: false,
        buyprice: false,
        sellprice: false,
        discount: false,
        inventory: false,
    }, //Control de estado para los inputs del formulario de añadir inventario

    inventory_update: {
        name: false,
        description: false,
        price: false,
        discount: false,
        status_select: false,
    }, //Control de estado para los inputs del formulario de actualizar accesorio

    inventory_add_units: {
        buyprice: false,
        newAmmount: false,
    },

    login: {
        email: false,
        password: false,
    }, //Control de estado para los inputs del formulario de iniciar sesión

    signup_admin: {
        name: false,
        email: false,
        documento: false,
        password: false,
        phone: false,
        address: false,
        rol: false,
    }, //Control de estado para los inputs del formulario de creación de cuenta con permisos

    signup_user: {
        name: false,
        email: false,
        documento: false,
        password: false,
        phone: false,
        address: false,
    }, //Control de estado para los inputs del formulario de creacón de cuenta

    signup_business: {
        name: false,
        email: false,
        documento: false,
        password: false,
        phone: false,
        address: false,
    }, //Control de estado para los inputs del formulario de creación de cuenta como emrpesa

    account_status: {
        state: false,
    }, //Control de estado para los inputs del formulario para cambiar el estado de cuenta

    account_update: {
        email: false,
        password: false,
        phone: false,
        address: false,
    },
};

// -------------------------------
// Selección de los elementos a validar

//Selección del formulario
const form = document.getElementsByClassName('input-form')[0];
//Selección de todos lo inputs
const inputs = document.querySelectorAll('.input-form .input--full-width');
//Selección de los posubles elementos select
const selection = document.getElementsByTagName('select')[0];
//Datos a validar
const keys = Object.keys(fields[form.dataset.form]);

// ----------------------------------------------------------------
// Funciones de validación

// Función para validar un campo
const validateField = (regEx, input, field) => {
    if (regEx.test(input.value)) {
        //Si es correcto
        fields[input.dataset.form][field] = true;
        document.getElementById(`${field}-group`).classList.remove('form-group--incorrect');
        document.getElementById(`${field}-group`).classList.add('form-group--correct');
        document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.remove('form-group__error-message--active');
    } else {
        fields[input.dataset.form][field] = false;
        document.getElementById(`${field}-group`).classList.remove('form-group--correct');
        document.getElementById(`${field}-group`).classList.add('form-group--incorrect');
        document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.add('form-group__error-message--active');
    }
};

//Cuando cambie un input, se llama la funciónd e validación
const validateForm = (e) => {
    validateField(regEx[e.target.dataset.form][e.target.name], e.target, e.target.name);
};

//Validación de los input
inputs.forEach((input) => {
    input.addEventListener('keyup', validateForm);
    input.addEventListener('blur', validateForm);
});

//Validación final cuando se hace submit
form.addEventListener('submit', (e) => {
    let inputsOK = true;

    for (let key_index = 0; key_index < keys.length; key_index++) {
        if (fields[e.target.dataset.form][keys[key_index]] === false) {
            inputsOK = false;
            break;
        }
    }

    if (inputsOK) {
        this.submit();
    } else {
        e.preventDefault();
        document.querySelector('.form__error-message').classList.add('form-group__error-message--active');

        setTimeout(() => {
            document.querySelector('.form__error-message').classList.remove('form-group__error-message--active');
        }, 5000);
    }
});
