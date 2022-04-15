//botones para buscar orden y hacer devolución
const btnSearch = document.getElementById('searchOrderBTN');
const btnRefund = document.getElementById('makeRefundBTN');
//complemento para la funcionalidad de alerts
const alertsContainer = document.querySelector('.aside-popup-container');
//inputs necesarios para el script
const inputOrder = document.getElementById('order');
const inputCantidadStatic = document.getElementById('cantidad_ds');
const inputCantidadInput = document.getElementById('cantidad_di');
const inputDefectuosos = document.getElementById('defectuoso');
const inputPrecio = document.getElementById('precio');
const inputFecha = document.getElementById('date');
const inputAccesorio = document.getElementById('id_accesorio');
//para trabajar el combobox
var sel = document.getElementById('accesorio_select');
//por defecto botón "hacer devolución" no aparece
btnRefund.style.display = 'none';

let globalOrder = [];

//complemento para la funcionalidad de alerts
function reloadAlerts() {
    setTimeout(() => {
        let alert = document.querySelector('.popup--active');
        alert.classList.remove('popup--active');
        alert.style.display = 'none';
        alert.remove();
    }, 3000);
}

// - variable generalizada para traer la orden y actualizar la cantidad, precio...
async function bringOrder(numOrder) {
    let response = await fetch('/employee/refunds/search_order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ order: numOrder }),
    });
    let data = await response.json();
    return data;
}

// - event listener cuando se cliquea buscar orden
btnSearch.addEventListener('click', async (e) => {
    //si la longitud del combobox es mayor a 0
    if (sel.length > 0) {
        //se borra el contenido del combobox
        for (var i = 0; i < sel.length; i++) {
            sel.remove(i);
            i--;
        }
        //se crea el primer elemento del combobox por defecto
        let option = document.createElement('option');
        option.innerHTML = '-- Seleccione un accesorio -- ';
        option.setAttribute('hidden', '');
        option.setAttribute('disabled', '');
        option.setAttribute('selected', '');
        option.value = '-';
        sel.appendChild(option);

        inputCantidadInput.removeAttribute('max');
    }
    //limpieza de campos
    inputCantidadStatic.value = '';
    inputCantidadInput.value = '';
    inputDefectuosos.value = '';
    inputPrecio.value = '';
    inputFecha.value = '';
    inputAccesorio.value = '';

    //se hace la búsqueda de la orden por medio de la función bringOrder y
    //se crean las alertas respectivas según el resultado
    const numOrder = inputOrder.value;
    globalOrder = await bringOrder(numOrder);

    const alert = document.createElement('div');
    alert.classList.add('popup');

    //si la orden no existe o no es valida:
    if (globalOrder.length == 0) {
        //Limpia el formulario
        inputOrder.value = '';
        btnRefund.style.display = 'none';

        //Envía la alerta
        alert.classList.add('popup--ward');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `No se encontró la orden de compra ${numOrder}`;
        alert.appendChild(paragraph);
    } else {
        //Si encontró una orden
        //aparece el botón para hacer devoluciones
        btnRefund.style.display = 'block';
        //se llena el combobox
        var opt = null;
        for (i = 0; i < globalOrder.length; i++) {
            opt = document.createElement('option');
            opt.value = i;
            opt.innerText = globalOrder[i].nombre;
            opt.classList.add('option');
            sel.appendChild(opt);
        }

        //Envía la alerta
        alert.classList.add('popup--success');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `Se encontró la orden de compra ${numOrder}`;
        alert.appendChild(paragraph);
    }

    //Añade la alerta al HTMl
    alertsContainer.appendChild(alert);
    //Recarga el script de las alertas
    reloadAlerts();
});

// - event listener cuando se cliquea para seleccionar un accesorio del combobox
sel.addEventListener('change', async (e) => {
    // - se llenan algunos inputs conforme la información cuando se trae la orden
    inputDefectuosos.value = '';
    inputAccesorio.value = globalOrder[sel.value].id_accesorio;
    inputCantidadStatic.value = globalOrder[sel.value].cantidad_venta;
    inputCantidadInput.value = globalOrder[sel.value].cantidad_venta;
    inputCantidadInput.setAttribute('max', parseInt(inputCantidadInput.value));
    const precioFinal = globalOrder[sel.value].precio_final;
    inputPrecio.value = parseInt(precioFinal) / parseInt(inputCantidadStatic.value);
    inputFecha.value = globalOrder[sel.value].fecha_compra;
});

// Event listeners para cuando haya cambio en el input de la cant a devolver
inputCantidadInput.addEventListener('input', (e) => {
    if (inputCantidadInput.value > parseInt(inputCantidadStatic.value)) {
        inputCantidadInput.value = parseInt(inputCantidadStatic.value);
    }
    if (inputCantidadInput.value < 0) {
        inputCantidadInput.value = 1;
    }
    inputCantidadInput.setAttribute('max', inputCantidadInput.value);
    if (inputDefectuosos.value > parseInt(inputCantidadInput.value)) {
        inputDefectuosos.value = parseInt(inputCantidadInput.max);
    }
});

// Event listeners para cuando haya cambio en el input defectuosos
inputDefectuosos.addEventListener('input', (e) => {
    if (inputDefectuosos.value > parseInt(inputCantidadInput.value)) {
        inputDefectuosos.value = parseInt(inputCantidadInput.max);
    }
    if (inputDefectuosos.value < 0) {
        inputDefectuosos.value = 1;
    }
});

// Alerta antes de concretar la devolución
if (btnRefund) {
    btnRefund.addEventListener('click', (e) => {
        if (!confirm('¿Desea concretar la devolución?')) {
            e.preventDefault();
        }
    });
}
