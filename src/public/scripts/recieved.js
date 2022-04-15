const btns = document.querySelectorAll('#recieved');
btns.forEach((btn) => {
    btn.addEventListener('click', (e) => {
        if (!confirm('¿Está seguro de reportar la orden de compra como recibida?')) {
            e.preventDefault();
        }
    });
});
