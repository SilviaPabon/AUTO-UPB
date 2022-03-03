window.addEventListener('DOMContentLoaded', (event) => {
    
    setTimeout(() => {
        const x = document.querySelector('.alert'); 

        //Espera 0.4s (Para que se muestre la transición) y le pone display none
        x.style.display = 'none';
    }, 4000);

}); 