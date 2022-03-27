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
            margins: { top: 20, left: 10, right: 10, bottom: 20 },
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
                base: `$ ${product['Precio Base']}`,
                disscount: `$ ${product['Descuento Aplicado']}`,
                taxes: `$ ${product['Impuestos Aplicados']}`,
                final: `$ ${product['Precio Final']}`,
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

        // Header del PDF que contiene la informaciónd de la venta
        doc.setDocumentHeader(
            {
                height: '22%',
            },
            () => {
                // Título de la factura
                doc.fontSize(20).text(`Factura de venta órden #${req.params.id}`, {
                    align: 'center',
                });
                doc.moveDown();

                // Información de la empresa y el cliente
                doc.fontSize(12).text(
                    `EMITIDO POR: Wearcar \nNIT: 020320227-7 \nDIRECCIÓN: Kilómetro 7 de la vía Piedecuesta-Floridablanca \nTELÉFONO: 6559860 \nCELULAR: 390 14 56 986\nEMITIDO A: ${billDetails[0][0]['Nombre cliente']} \nIDENTIFICADO CON: ${billDetails[0][0]['Cédula cliente']}`,
                    {
                        columns: 2,
                        columnGap: 15,
                        height: 90,
                        width: 640,
                    }
                );
                doc.moveDown(6);

                billDetails[0][0]['Nombre vendedor'] != null
                    ? doc.fontSize(12).text(`RESPONSABLE DE LA VENTA: ${billDetails[0][0]['Nombre vendedor']}`)
                    : doc.fontSize(12).text('VENTA REALIZADA POR: Compra web');
            }
        );

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
                headAlign: 'left',
                headBackground: '#36c9b8',
                cellsPadding: 10,
                marginBottom: 20,
            }
        );

        doc.addTable(
            [
                { key: 'Subtotal', label: 'Subtotal', align: 'left' },
                { key: 'Total_descuentos', label: 'Total descuentos', align: 'left' },
                { key: 'Total_impuestos', label: 'Total impuestos', align: 'left' },
                { key: 'Total', label: 'Total', align: 'left' },
            ],
            [
                {
                    Subtotal: `$ ${billDetails[0][0]['Total Precios Base']}`,
                    Total_descuentos: `$ ${billDetails[0][0]['Descuentos aplicados']}`,
                    Total_impuestos: `$ ${billDetails[0][0]['IVA aplicado']}`,
                    Total: `$ ${billDetails[0][0]['Total']}`,
                },
            ],
            {
                border: null,
                width: 'fill_body',
                striped: true,
                stripedColors: ['#fff', '#ececec'],
                headAlign: 'left',
                headBackground: '#36c9b8',
                cellsPadding: 10,
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