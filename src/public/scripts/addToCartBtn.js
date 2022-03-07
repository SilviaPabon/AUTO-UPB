const btns = document.querySelectorAll('#addToCartBtn');
const featuredSection = document.getElementById('featured');
const disscountSection = document.getElementById('disscount');  

// -----
// Función para recargar nuevas alertas
function reloadAlerts() {
    setTimeout(() => {
        let alerts = document.querySelectorAll('.alert');
        
        alerts.forEach(alert => {
            alert.style.display = 'none';
            alert.remove(); 
        });
    }, 4000);
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

        // Si se agregó el accesorio, se envía una alerta de success
        if (response.status == 200) {
            //Crea la alerta
            const main = document.getElementsByTagName('main');
            const alert = document.createElement('div');
            alert.classList.add('alert');
            alert.classList.add('alert--success');
            const paragraph = document.createElement('p');
            paragraph.innerText = 'OPERACIÓN EXITOSA, EL ACCESORIO FUE AÑADIDO AL CARRITO';
            alert.appendChild(paragraph);

            //La añade en la sección que corresponda

            console.log(btn); 

            if(btn.getAttribute('href') == '#disscount'){
                disscountSection.insertBefore(alert, disscountSection.children[1]); 
            }else if (btn.getAttribute('href') == '#featured'){
                featuredSection.insertBefore(alert, featuredSection.children[1]); 
            }

            //Recarga el script de las alertas
            reloadAlerts();
        }
    });
});
