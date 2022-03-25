const inputs = document.querySelectorAll('#contact_us .input--full-width');
const form = document.getElementById('contact_us');

const regEx = {
    email: /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/,
    name: /^[a-zA-ZÀ-ÿ\s]{1,40}$/,
    message: /^.{10,255}$/
    
};

const fields = {
    name: false,
    email: false,
    message: false
};

const validateForm = (e) => {
    switch (e.target.name) {
        case 'name':
            validateField(regEx.name, e.target, e.target.name);
            break;

        case 'email':
            validateField(regEx.email, e.target, e.target.name);
            break;
        
        case 'message':
            validateField(regEx.message, e.target, e.target.name);
            break;
    }
}

const validateField = (regEx, input, field) => {
    if (regEx.test(input.value)) {
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
}


inputs.forEach((input) => {
    input.addEventListener('keyup', validateForm);
    input.addEventListener('blur', validateForm);
});

form.addEventListener('submit', (e) => {
    //Verificar que todos los campos sean correctos
    if (
        fields.name &&
        fields.message &&
        fields.email
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