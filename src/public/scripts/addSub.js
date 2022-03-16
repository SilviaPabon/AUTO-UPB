const container = document.querySelector('.generic-table').children[1].children
const table = document.getElementById('input')
let contador = 0

for (let i = 0; i < container.length; i++) {
    container[i].addEventListener('click', e => {
        if (e.target.classList.contains('btn--amount-b')){
            container[i].getElementsByTagName('input')[0].value = parseInt(container[i].getElementsByTagName('input')[0].value) + 1;
        } 
        if (e.target.classList.contains('btn--amount-a')){
            container[i].getElementsByTagName('input')[0].value = container[i].getElementsByTagName('input')[0].value - 1;
        }
        e.stopPropagation();
    });
}


// e evento
/* container.addEventListener('click', e => {
     //el evento que contenga la clase tal
    if (e.target.classList.contains('btn--amount-b')){
        contador++
        table.value = contador
    } 
    if (e.target.classList.contains('btn--amount-a')){
        contador--
        table.value = contador
    }
    e.stopPropagation() //para evitar conteos en otras partes, por propagación
}) */


    