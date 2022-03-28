const inputs = document.querySelectorAll('#signup-form .input--full-width');
const form = document.getElementById('signup-form');

const regEx = {
    name: /^.{5,85}$/, //Contiene 2 a 100 caracteres
    documento: new RegExp('^[0-9]{9}(-[0-9]{1})$'), // Formato del NIT 
    email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
    password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$!%*#?&/%])[A-Za-z\d$!%*#?&/%]{8,}$/, // Mínimo 8 dígitos, con una letra, un número y un caracter especial
    phone: /^\d{7,10}$/, // 7 a 10 numeros.
    address: /^.{15,100}$/ //Ce 15 a 100 caracteres
};

const fields = {
    name: false,
    email: false,
    documento: false,
    password: false,
    phone: false, 
    address: false, 
};

const validateForm = (e) => {
    switch (e.target.name) {
        case 'name':
            validateField(regEx.name, e.target, e.target.name);
            break;

        case 'documento':
            validateField(regEx.documento, e.target, e.target.name);
            break;

        case 'email':
            validateField(regEx.email, e.target, e.target.name);
            break;

        case 'password':
            validateField(regEx.password, e.target, e.target.name);
            break;

        case 'phone':
        validateField(regEx.phone, e.target, e.target.name);
        break;

        case 'address':
        validateField(regEx.address, e.target, e.target.name);
        break;
    }
};

const validateField = (regEx, input, field) => {
    if (regEx.test(input.value.replaceAll(' ', ''))) {
        //Si es correcto
        fields[field] = true;
        document.getElementById(`${field}-group`).classList.remove('form-group--incorrect');
        document.getElementById(`${field}-group`).classList.add('form-group--correct');
        document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.remove('form-group__error-message--active');
    } else {
        fields[field] = false;
        document.getElementById(`${field}-group`).classList.remove('form-group--correct');
        document.getElementById(`${field}-group`).classList.add('form-group--incorrect');
        document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.add('form-group__error-message--active');
    }
};

inputs.forEach((input) => {
    input.addEventListener('keyup', validateForm);
    input.addEventListener('blur', validateForm);
});

form.addEventListener('submit', (e) => {
    //Verificar que todos los campos sean correctos
    if (
        fields.name &&
        fields.email &&
        fields.documento &&
        fields.password &&
        fields.phone &&
        fields.address
    ) {
        this.submit();
    } else {
        e.preventDefault();
        document.querySelector('.form__error-message').classList.add('form-group__error-message--active');

        setTimeout(() => {
            document.querySelector('.form__error-message').classList.remove('form-group__error-message--active');
        }, 5000);
    }
});
