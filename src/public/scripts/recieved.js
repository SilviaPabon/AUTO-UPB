const btn_deactivate = document.getElementById('deactivate_account');
const btns = document.querySelectorAll('#recieved');
btns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
        if (!confirm(`¿Está seguro de reportar la orden de compra como recibida?`)) {
            e.preventDefault();
        }
    });
});
