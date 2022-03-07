const alertsContainer = document.querySelector('.aside-popup-container');
const btns = document.querySelectorAll('#addToCartBtn');
const featuredSection = document.getElementById('featured');
const disscountSection = document.getElementById('disscount');

// -----
// Función para recargar nuevas alertas
function reloadAlerts() {
    setTimeout(() => {
        let alert = document.querySelector('.popup--active');
        alert.classList.remove('popup--active');
        alert.style.display = 'none';
        alert.remove();
    }, 3000);
}

btns.forEach((btn) => {
    btn.addEventListener('click', async () => {
        // Toma el id del accesorio
        const id = btn.dataset.id;

        // Hace la petición post correspondiente
        const response = await fetch('/cart/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: id }),
        });

        const alert = document.createElement('div');
        alert.classList.add('popup');

        // Si se agregó el accesorio, se envía una alerta de success
        if (response.status == 200) {
            //Le añade la clase success y active a la alerta
            alert.classList.add('popup--success');
            alert.classList.add('popup--active');
            const paragraph = document.createElement('p');
            paragraph.innerText = `El accesorio ${btn.parentElement.parentElement.children[0].innerText.toLowerCase()} fue agregado satisfactoriamente al carrito`;
            alert.appendChild(paragraph);
        } else {
            //Le añade la clase ward y active a la alerta
            alert.classList.add('popup--ward');
            alert.classList.add('popup--active');
            const paragraph = document.createElement('p');
            paragraph.innerText = `No hay suficiente stock para agregar una ${btn.parentElement.parentElement.children[0].innerText.toLowerCase()} al carrito`;
            alert.appendChild(paragraph);
        }

        //Añade la alerta al HTMl
        alertsContainer.appendChild(alert);
        //Recarga el script de las alertas
        reloadAlerts();
    });
});
