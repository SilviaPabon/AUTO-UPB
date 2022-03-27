const controller = {};
const pool = require('../database/connection');
const PDF = require('pdfkit-construct');

// ----------------------------------------------------------------
//Controlador para que el cliente pueda ver sus órdenes de compra
controller.orderClient = async (req, res) => {
    let queryOk = false;

    try {
        var clientOrders = await pool.query('CALL GET_USER_ORDERBUY_FROM_ID(?)', [req.user.id_usuario]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if (queryOk) {
        const data = clientOrders[0];

        if (data.length > 0) {
            res.render('clients/orders_clients', { data });
        } else {
            req.flash('message', 'No hay órdenes de compra para mostrar');
            res.redirect('/');
        }
    } else {
        req.flash('message', 'Error inesperado en la consulta a la base de datos');
        res.redirect('/');
    }
};

// ----------------------------------------------------------------
// Controlador para mostrar la factura de la compra del cliente
controller.user_bill = async (req, res) => {
    let queryOk = false;

    //Obtención de los datos de la factura
    try {
        var billDetails = await pool.query('CALL get_bill_details_from_id(?, ?)', [req.user.id_usuario, req.params.id]);
        queryOk = true;
    } catch (error) {
        queryOk = false;
    }

    if (queryOk) {
        //Documento PDF generado dinámicamente
        const doc = new PDF({
            size: 'A4',
            bufferPages: true,
        });

        //Parámetros de ayuda
        const date = new Date();
        const fileName = `Orden_N${req.params.id}_${date.toLocaleDateString()}.pdf`;

        // Metadatos del documento
        doc.info = {
            Title: fileName,
            Author: 'Wearcar',
            Subject: `Factura de la orden de compra ${req.params.id}`,
            CreationDate: date.toLocaleDateString(),
        };

        // Datos que serán mostrados en forma de tabla
        const dataAccessories = [];
        const productsArray = JSON.parse(billDetails[0][0]['productos']);

        productsArray.forEach((product) => { 
            dataAccessories.push({
                name: product['Accesorio'],
                amount: product['Cantidad'],
                base: product['Precio Base'],
                disscount: product['Descuento Aplicado'],
                taxes: product['Impuestos Aplicados'],
                final: product['Precio Final'],
            });
        });


        // Manejo del documento PDF como una respuesta HTTP
        const stream = res.writeHead(200, {
            'Content-Type': 'application/pdf',
            'Content-Disposition': `attachment; filename=${fileName}`,
        });

        doc.on('data', (data) => {
            stream.write(data);
        });

        doc.on('end', () => {
            stream.end();
        });

        // Contenido del documento PDF
        doc.addTable(
            [
                { key: 'name', label: 'Nombre', align: 'left' },
                { key: 'amount', label: 'Cantidad', align: 'left' },
                { key: 'base', label: 'Precio base', align: 'left' },
                { key: 'disscount', label: 'Descuento', align: 'left' },
                { key: 'taxes', label: 'IVA', align: 'left' },
                { key: 'final', label: 'Precio final', align: 'left' },
            ],
            dataAccessories,
            {
                border: null,
                width: 'fill_body',
                striped: true,
                stripedColors: ['#fff', '#ececec'],
                headAlign: 'center',
                cellsPadding: 10
            }
        );

        doc.render(); 

        doc.end();
    } else {
        req.flash('message', 'Error en la consulta de la factura');
        res.redirect('/user/orders');
    }
};

module.exports = controller;
