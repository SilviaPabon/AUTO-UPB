const inputs = document.querySelectorAll('#signup-form .input--full-width');
const form = document.getElementById('signup-form');


const regEx = {
    buyprice: /^\d{2,12}$/,
    newAmmount: /^\d{1,4}$/,
};

const fields = {
    buyprice: false,
    newAmmount: false,
};

const validateForm = (e) => {
    switch (e.target.name) {

        case 'buyprice':
            validateField(regEx.buyprice, e.target, e.target.name);
            break;

        case 'newAmmount':
            validateField(regEx.newAmmount, e.target, e.target.name);
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
    console.log(fields);
    if (
        fields.buyprice &&
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