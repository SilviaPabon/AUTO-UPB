const alertsContainer = document.querySelector('.aside-popup-container');
const container = document.querySelector('.generic-table').children[1].children;
const btn_buy = document.querySelectorAll('.buy-btn');

// Gets resume table tbody
const resume = document.querySelector('.shopping_resume').childNodes[3].children[0];
// Gets subtotal, taxes, disscounts and total table column
const subtotal = resume.children[0].children[1];
const impuestos = resume.children[1].children[1];
const descuentos = resume.children[2].children[1];
const total = resume.children[3].children[1];

// ----
// Función para actualizar la tabla de resumen de orden de compra
function updateResume(){
    let subtotalAcum = 0; 
    let initialPricesAcum = 0; 

    //Itera a través de las filas de la tabla para obtener los datos del resumen
    for(let i=0; i < container.length; i++){
        let row = container[i]; 
        subtotalAcum += parseInt(row.children[5].innerText);
        initialPricesAcum +=  parseInt(row.children[2].innerText) * parseInt(row.children[4].children[0].children[2].value);
    }

    subtotal.innerText = subtotalAcum; 
    descuentos.innerText = initialPricesAcum - subtotalAcum; 
    impuestos.innerText = subtotalAcum * 0.19; 
    total.innerText = subtotalAcum + parseInt(impuestos.innerText); 
}

// ----
// Función para actualizar la columna de una fila específica
function updateRow(input) {
    //Get parent row
    const parentRow = input.parentElement.parentElement.parentElement;

    //Update final price row from base price and amount
    const basePrice = parseInt(parentRow.children[2].innerText)
    const disscount = (parseInt(parentRow.children[2].innerText) * parseInt(parentRow.children[3].innerText)) / 100
    parentRow.children[5].innerText = (basePrice - disscount) * input.value;

    //Llamada a la función para actualizar la tabla del resumen
    updateResume(); 
}

// ----
// Función para recargar las alertas cuando se añada una nueva

function reloadAlerts() {
    setTimeout(() => {
        let alert = document.querySelector('.popup--active');
        alert.classList.remove('popup--active');
        alert.style.display = 'none';
        alert.remove();
    }, 3000);
}

// -----
// función para enviar el post a la ruta de actualización del carrito
const postChange = async (inputField) => {

    // Actualiza la fila del registro
    updateRow(inputField); 

    // Envía el post para actualizar el carrito
    const value = inputField.value;
    const { id } = inputField.dataset;

    const response = await fetch('/cart/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id: id, amount: value }),
    });

    const alert = document.createElement('div');
    alert.classList.add('popup');

    // Si se agregó el accesorio, se envía una alerta de success
    if (response.status == 200) {
        //Le añade la clase success y active a la alerta
        alert.classList.add('popup--success');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `Se modificó la cantidad del accesorio`;
        alert.appendChild(paragraph);
    } else {
        //Le añade la clase ward y active a la alerta
        alert.classList.add('popup--ward');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `Ocurrió un error al modificar la cantidad`;
        alert.appendChild(paragraph);
    }

    //Añade la alerta al HTMl
    alertsContainer.appendChild(alert);
    //Recarga el script de las alertas
    reloadAlerts();
};

// ----
// Evnet listeners para registrar los clicks en los botones y el propio input
for (let i = 0; i < container.length; i++) {
    container[i].querySelector('.btn--amount-b').addEventListener('click', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value <
            parseInt(container[i].getElementsByTagName('input')[0].attributes['max'].value)
        ) {
            container[i].getElementsByTagName('input')[0].value = parseInt(
                container[i].getElementsByTagName('input')[0].value) + 1;
            postChange(container[i].getElementsByTagName('input')[0]);
        }

        e.stopPropagation();
    });
    container[i].querySelector('.btn--amount-a').addEventListener('click', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value >
            parseInt(container[i].getElementsByTagName('input')[0].max)
        ) {
            container[i].getElementsByTagName('input')[0].value = parseInt(
                container[i].getElementsByTagName('input')[0].max
            );
        } else if (container[i].getElementsByTagName('input')[0].value > 1) {
            container[i].getElementsByTagName('input')[0].value =
                parseInt(container[i].getElementsByTagName('input')[0].value) - 1;
            postChange(container[i].getElementsByTagName('input')[0]);
        }
    });
    container[i].getElementsByTagName('input')[0].addEventListener('input', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value >
            parseInt(container[i].getElementsByTagName('input')[0].max)
        ) {
            container[i].getElementsByTagName('input')[0].value = parseInt(
                container[i].getElementsByTagName('input')[0].max
            );
        }
        if (container[i].getElementsByTagName('input')[0].value < 1) {
            container[i].getElementsByTagName('input')[0].value = parseInt(1);
        }
        postChange(e.target);
    });
}

if (btn_buy){
    const btn_array = Array.from(btn_buy);

    btn_array.forEach((btn) => {
        btn.addEventListener('click', (e) => {
            if (!confirm('¿Desea realizar la compra?')) {
                e.preventDefault();
            }
        });
    });
}