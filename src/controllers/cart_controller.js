const controller = {};
const connection = require('../database/connection');

// -----------
// Ruta para añadir un accesorio al carrito
controller.cartAdd = async (req, res) => {
    const { id } = req.body;

    // Inicializa el objeto y las variables de control
    let item = {};
    let success = false;
    let itemIndexOnCart = -1;

    // Se obtiene la variable global del carrito
    const cart = req.session.cart;

    // Revisa si ya existe el accesorio en el carrito
    for (let index = 0; index < cart.length; index++) {
        if (cart[index].id_accesorio == id) {
            itemIndexOnCart = index;
            break;
        }
    }

    if (itemIndexOnCart == -1) {
        //Si el accesorio no existe en el carrito, lo agrega
        try {
            // Consulta a la base de datos para obtener el accesorio
            const queryResponse = await connection.query('CALL SHOW_ACCESSORY_DETAILS(?)', [id]);

            if (queryResponse[0][0].stock >= 1) {
                item.id_accesorio = queryResponse[0][0].id_accesorio;
                item.nombre = queryResponse[0][0].nombre;
                item.stock = queryResponse[0][0].stock;
                item.precio_base = queryResponse[0][0].precio_base;
                item.descuento = queryResponse[0][0].descuento;
                item.precio_final = queryResponse[0][0].precio_final;
                item.ruta_imagen = queryResponse[0][0].ruta_imagen;
                item.cantidad = 1;

                cart.push(item);

                success = true;
            }
        } catch (error) {
            success = false;
        }
    } else {
        //Si el accesorio ya existe en el carrito, le agrega una unidad
        item = cart[itemIndexOnCart];

        //Revisa que aún tenga stock
        if (item.stock > item.cantidad) {
            item.cantidad += 1;
            success = true;
        }
    }

    // Se envía la respuesta según si la operación fue exitosa o no
    success == true
        ? res.status(200).json({
              status: 'El accesorio fue agregado exitosamente',
          })
        : res.status(404).json({
              status: 'No se econtró el accesorio dado',
          });
};

// ------
// Ruta get usada por los botones para remover un accesorio del carrito
controller.cartRemoveGet = async (req, res) => {
    const { id } = req.params;
    const cart = req.session.cart;
    let accessoryName = ''; 
    let success = false;

    // Buscar si el elemento existe en en carrito de compras
    for (let index = 0; index < cart.length; index++) {
        // Si encuentra el accesorio lo remueve del array y cambia la variable de control success a true
        if (cart[index].id_accesorio == id) {
            accessoryName = cart[index].nombre; 
            cart.splice(index, 1);
            success = true;
            break;
        }
    }

    if (success) {
        req.flash('success', `Operación exitosa: El accesorio: ${accessoryName}, fue removido del carrito`);
        res.redirect('/');
    } else {
        req.flash('message', 'Error: El accesorio a eliminar no fue encontrado en el carrito');
        res.redirect('/');
    }
};

module.exports = controller;
