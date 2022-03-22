const form = document.getElementById('updstate-form');
const selection = document.getElementById('state-group');

const fields = {
    state: false, 
};

const validateForm = (e) => {
    switch (e.target.name) {
        case 'state':
            validateOption(e.target, e.target.name)
        break;
    }
};

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

selection.addEventListener("change", validateForm);

form.addEventListener('submit', (e) => {

    if (
        fields.state
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