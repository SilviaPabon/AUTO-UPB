const btnSearch = document.getElementById('searchOrderBTN'); 

const alertsContainer = document.querySelector('.aside-popup-container');

const inputOrder = document.getElementById('order'); 
const inputCantidad = document.querySelectorAll('#cantidad_d');  
const inputPrecio = document.getElementById('precio');
const inputFecha = document.getElementById('date');
var sel = document.getElementById('accesorio_select');

function reloadAlerts() {
    setTimeout(() => {
        let alert = document.querySelector('.popup--active');
        alert.classList.remove('popup--active');
        alert.style.display = 'none';
        alert.remove();
    }, 3000);
}

btnSearch.addEventListener('click', async e => {
    
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

        inputCantidad[0].value = "";
        inputCantidad[1].value = "";
        inputFecha.value = "";
        
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

    // Procede según si existe el usuario
    if(responseFormated.length == 0){
        //Si no se encontró un usuario
        
        //Reemplaza los campos del formulario
        inputOrder.value = "";
        inputCantidad[0].value = "";
        inputCantidad[1].value = "";
        inputFecha.value = "";

        //Envía la alerta
        alert.classList.add('popup--ward');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `No se encontró la orden de compra ${numOrder}`;
        alert.appendChild(paragraph);
    }else{
        //Si encontró un usuario
        
        var opt = null;
        for(i = 0; i < responseFormated.length; i++) { 
            opt = document.createElement('option');
            opt.value = i;
            opt.innerHTML = responseFormated[i].id_accesorio;
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

    inputCantidad[0].value = responseFormated[sel.value].cantidad_venta;
    inputCantidad[1].value = responseFormated[sel.value].cantidad_venta;
    inputFecha.value = responseFormated[sel.value].fecha_compra;
});

// Evnet listeners para registrar los clicks en los botones y el propio input
/* for (let i = 0; i < container.length; i++) {
    inputCantidad.addEventListener('input', (e) => {
        if (
            inputCantidad.value >
            parseInt(inputCantidad.max)
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
} */

/* if (btn_buy){
    const btn_array = Array.from(btn_buy);

    btn_array.forEach((btn) => {
        btn.addEventListener('click', (e) => {
            if (!confirm('¿Desea realizar la compra?')) {
                e.preventDefault();
            }
        });
    });
} */