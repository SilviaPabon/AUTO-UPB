const inputs = document.querySelectorAll('#signup-form .input--full-width');
const form = document.getElementById('signup-form');


const regEx = {
    name: /^.{3,64}$/, //15 a 64 caracteres
    description: /^.{10,324}$/, //15 a 64 caracteres
    buyprice: /^\d{2,12}$/,
    sellprice: /^\d{2,12}$/,
    inventory: /^\d{1,4}$/,
    discount: /^\d{1,3}$/
};

const fields = {
    name: false,
    description: false,
    buyprice: false,
    sellprice: false,
    discount: false, 
    inventory: false,
};

const validateForm = (e) => {
    switch (e.target.name) {
        case 'name':
            validateField(regEx.name, e.target, e.target.name);
            break;

        case 'description':
            validateField(regEx.description, e.target, e.target.name);
            break;

        case 'buyprice':
            validateField(regEx.buyprice, e.target, e.target.name);
            break;

        case 'sellprice':
            validateField(regEx.sellprice, e.target, e.target.name);
            break;

        case 'discount':
            validateField(regEx.discount, e.target, e.target.name);
        break;

        case 'inventory':
            validateField(regEx.inventory, e.target, e.target.name);
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

inputs.forEach((input) => {
    input.addEventListener('keyup', validateForm);
    input.addEventListener('blur', validateForm);
});

form.addEventListener('submit', (e) => {
    //Verificar que todos los campos sean correctos
    if (
        fields.name &&
        fields.description &&
        fields.buyprice &&
        fields.sellprice &&
        fields.discount &&
        fields.inventory
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