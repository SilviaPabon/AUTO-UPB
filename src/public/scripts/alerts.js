const alertsClose = document.querySelectorAll('.alert__close');

alertsClose.forEach((x) => {
    x.addEventListener('click', () => {
        //Por cada signo de cerrar en las alertas, si se hace click:

        //Accede a su padre (el div) y le pone la opacidad en cero
        const parent = x.parentElement;
        parent.style.opacity = 0;

        //Espera 0.4s (Para que se muestre la transición) y le pone display none
        window.setTimeout(function setDisplayNone() {
            parent.style.display = 'none';
        }, 400);
    });
});