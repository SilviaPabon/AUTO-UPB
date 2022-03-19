const btnSearch = document.getElementById('searchClientBTN'); 

const inputId = document.getElementById('id_usuario'); 
const inputCedula = document.getElementById('documento'); 
const inputNombre = document.getElementById('name');
const inputMail = document.getElementById('email');
const inputPhone = document.getElementById('phone');
const inputDireccion = document.getElementById('address');     

btnSearch.addEventListener('click', async e => {
    
    const cedula = inputCedula.value; 

    // Envía el post a la ruta definida para obtener los datos del cliente
    const response = await fetch('/employee/cart/user_exists', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ documento: cedula }),
    });

    // Pasa la respuesta al formato JSON
    const responseFormated = await response.json();  
    console.log(responseFormated); 

    const alert = document.createElement('div');
    alert.classList.add('popup');

    // Procede según si existe el usuario
    if(responseFormated.length == 0){
        //Si no se encontró un usuario
        
        //Reemplaza los campos del formulario
        inputNombre.value = ''; 
        inputDireccion.value = ''; 
        inputMail.value = ''; 
        inputPhone.value = ''; 

        //Envía la alerta
        alert.classList.add('popup--ward');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `No se encontró el usuario con la cédula ${cedula}`;
        alert.appendChild(paragraph);
    }else{
        //Si encontró un usuario

        //Reemplaza los campos del formulario
        inputId.value = responseFormated[0].id_usuario; 
        inputNombre.value = responseFormated[0].nombre; 
        inputDireccion.value = responseFormated[0].direccion; 
        inputMail.value = responseFormated[0].correo_electronico; 
        inputPhone.value = responseFormated[0].telefono; 

        //Envía la alerta
        alert.classList.add('popup--success');
        alert.classList.add('popup--active');
        const paragraph = document.createElement('p');
        paragraph.innerText = `Se encontró el usuario con la cédula ${cedula}`;
        alert.appendChild(paragraph);
    }

    //Añade la alerta al HTMl
    alertsContainer.appendChild(alert);
    //Recarga el script de las alertas
    reloadAlerts();

}); 