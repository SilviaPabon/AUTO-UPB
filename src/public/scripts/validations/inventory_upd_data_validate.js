const inputs = document.querySelectorAll('#modify-form .input--full-width');
const form = document.getElementById('modify-form');
const selection = document.getElementById('status_select');


const regEx = {
    name: /^.{3,64}$/, 
    description: /^.{10,324}$/, 
    price: /^\d{2,12}$/,
    discount: /^\d{1,3}$/
};

const fields = {
    name: false,
    description: false,
    price: false,
    discount: false, 
    status_select: false
};

const validateForm = (e) => {
    switch (e.target.name) {
        case 'name':
            validateField(regEx.name, e.target, e.target.name);
            break;

        case 'description':
            validateField(regEx.description, e.target, e.target.name);
            break;

        case 'price':
            validateField(regEx.price, e.target, e.target.name);
            break;

        case 'discount':
            validateField(regEx.discount, e.target, e.target.name);
        break;

        case 'status_select':
            validateOption(e.target, e.target.name)
        break;
    }
};

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

const validateOption = (select, field) => {
    if (select.value == 0) {
        fields[field] = false;
        document.getElementById(`${field}-group`).classList.remove('form-group--correct');
        document.getElementById(`${field}-group`).classList.add('form-group--incorrect');
        document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.add('form-group__error-message--active');
    } else {
        fields[field] = true;
        document.getElementById(`${field}-group`).classList.remove('form-group--incorrect');
        document.getElementById(`${field}-group`).classList.add('form-group--correct');
            document
            .querySelector(`#${field}-group .form-group__error-message`)
            .classList.remove('form-group__error-message--active');
    }
}

inputs.forEach((input) => {
    input.addEventListener('keyup', validateForm);
    input.addEventListener('blur', validateForm);
});

selection.addEventListener("change", validateForm);

form.addEventListener('submit', (e) => {
    //Verificar que todos los campos sean correctos
    if (
        fields.name &&
        fields.description &&
        fields.price &&
        fields.discount &&
        fields.status_select
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