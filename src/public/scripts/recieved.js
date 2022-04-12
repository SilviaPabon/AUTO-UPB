const btn_deactivate = document.getElementById('deactivate_account');
const btns = document.querySelectorAll('#recieved');
btns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
        if (!confirm(`¿Está seguro de reportar este producto como recibido?`)) {
            e.preventDefault();
        }
    });
});
