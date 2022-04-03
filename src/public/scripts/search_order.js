const btnSearch = document.getElementById('searchOrderBTN'); 
const btnRefund = document.getElementById('makeRefundBTN');

const alertsContainer = document.querySelector('.aside-popup-container');

const inputOrder = document.getElementById('order'); 
const inputCantidadStatic = document.getElementById('cantidad_ds');
const inputCantidadInput = document.getElementById('cantidad_di');
const inputDefectuosos = document.getElementById('defectuoso');    
const inputPrecio = document.getElementById('precio');
const inputFecha = document.getElementById('date');
const inputAccesorio = document.getElementById('id_accesorio');

var sel = document.getElementById('accesorio_select');
btnRefund.style.display = "none";

function reloadAlerts() {
    setTimeout(() => {
        let alert = document.querySelector('.popup--active');
        alert.classList.remove('popup--active');
        alert.style.display = 'none';
        alert.remove();
    }, 3000);
}

btnSearch.addEventListener('click', async e => {
    btnRefund.style.display = "none";
    if (sel.length > 0) {
        
        for (var i=0; i < sel.length; i++) {
            sel.remove(i);
            i--;
        }

        let option = document.createElement('option');
        option.innerHTML = '-- Seleccione un accesorio -- ';
        option.setAttribute("hidden", "");
        option.setAttribute("disabled", "");
        option.setAttribute("selected", "");
        option.value = "-";
        sel.appendChild(option);

        inputCantidadStatic.value = "";
        inputCantidadInput.value = "";
        inputDefectuosos.value = "";
        inputPrecio.value = "";
        inputFecha.value = "";
        inputCantidadInput.removeAttribute("max");

        btnRefund.style.display = "block";
        
    }
    
    const numOrder = inputOrder.value; 

    // Envía el post a la ruta definida para obtener los datos del cliente
    const response = await fetch('/employee/refunds/search_order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ order: numOrder }),
    });

    // Pasa la respuesta al formato JSON
    const responseFormated = await response.json();  

    const alert = document.createElement('div');
    alert.classList.add('popup');

    // 
    if(responseFormated.length == 0){
        //
        
        //Reemplaza los campos del formulario
        inputOrder.value = "";
        inputCantidadStatic.value = "";
        inputCantidadInput.value = "";
        inputPrecio.value = "";
        inputFecha.value = "";
        inputAccesorio.value = "";
        btnRefund.style.display = "none";

        //Envía la alerta
        alert.classList.add('popup--ward');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `No se encontró la orden de compra ${numOrder}`;
        alert.appendChild(paragraph);
    }else{
        //Si encontró una orden
        
        var opt = null;
        for(i = 0; i < responseFormated.length; i++) { 
            opt = document.createElement('option');
            opt.value = i;
            opt.innerHTML = responseFormated[i].nombre;
            sel.appendChild(opt);
        };
        
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

sel.addEventListener("change", async e => {
    
    const numOrder = inputOrder.value;

    const response = await fetch('/employee/refunds/search_order', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ order: numOrder }),
    });

    const responseFormated = await response.json();
    inputDefectuosos.value = "";
    inputAccesorio.value = responseFormated[sel.value].id_accesorio;
    inputCantidadStatic.value = responseFormated[sel.value].cantidad_venta;
    inputCantidadInput.value = responseFormated[sel.value].cantidad_venta;
    inputCantidadInput.setAttribute("max", parseInt(inputCantidadInput.value));
    const precioFinal = responseFormated[sel.value].precio_final
    inputPrecio.value = parseInt(precioFinal) / parseInt(inputCantidadStatic.value);
    inputFecha.value = responseFormated[sel.value].fecha_compra;
});
// Event listeners para cuando haya cambio en el input de la cant a devolver
inputCantidadInput.addEventListener('input', (e) => {
    if (
        inputCantidadInput.value >
        parseInt(inputCantidadStatic.value)
    ) {
        inputCantidadInput.value = parseInt(inputCantidadStatic.value)
    }
    if (inputCantidadInput.value < 0) {
        inputCantidadInput.value = 1;
    }
    inputCantidadInput.setAttribute("max", inputCantidadInput.value);
})

// Event listeners para cuando haya cambio en el input defectuosos
inputDefectuosos.addEventListener('input', (e) => {
    if (
        inputDefectuosos.value >
        parseInt(inputCantidadInput.value)
    ) {
        inputDefectuosos.value = parseInt(inputCantidadInput.max)
    }
    if (inputDefectuosos.value < 0) {
        inputDefectuosos.value = 1;
    }
});


if (btnRefund){

    btnRefund.addEventListener('click', (e) => {
        if (!confirm('¿Desea concretar la devolución?')) {
            e.preventDefault();
        }
    });
}