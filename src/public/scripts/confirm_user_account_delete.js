const btn_deactivate = document.getElementById('deactivate_account');

btn_deactivate.addEventListener('click', (e) => {
    if (
        !confirm(
            `¿Está seguro de que quiere desactivar su cuenta? En caso de querer reactivar la cuenta luego de la desactivación, puede contactar a un administrador mediante el formulario de contacto dispuesto en la opción ESCRÍBENOS`
        )
    ) {
        e.preventDefault();
    }
});
