
const navIcon = document.querySelector('.menu-toggle'); 
const navList = document.querySelector('.menu'); 
const body = document.getElementsByTagName('body')[0]; 

//Cuando se haga click sobre el menú de celulares, despliega el menú lateral
navIcon.addEventListener('click', ()=>{
    navList.classList.toggle('menu-visible'); 
    body.classList.toggle('body--fixed');

    if(navList.classList.contains('menu-visible')){
        navIcon.setAttribute('aria-label', 'Cerrar menu'); 
    }else{
        navIcon.setAttribute('aria-label', 'Abrir menu'); 
    }
}); 