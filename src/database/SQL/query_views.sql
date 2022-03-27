/* ########################## */
/* VISTAS */
/* ########################## */

/*VISTA PARA TOMAR LOS DATOS DE LA SESIÓN DEL USUARIO EN LA APLICACIÓN WEB*/
CREATE VIEW SESSION_USER_DATA AS
SELECT id_usuario, nombre, correo_electronico, contraseña, codigo_tipo_usuario, codigo_estado_cuenta
FROM USUARIOS; 

/*VISTA PARA MOSTRAR LA INFORMACIÓN DEL USUARIO DE UN MOOD FACIL DE LEER*/
DROP VIEW IF EXISTS USERS_PRETTY;
CREATE VIEW USERS_PRETTY AS
SELECT u.id_usuario, u.nombre, u.identificacion, u.direccion, u.aceptacion_terminos, tu.tipo_usuario, u.telefono, u.correo_electronico, e.estado_cuenta
FROM USUARIOS as u, TIPOS_ESTADO_CUENTA as e, TIPOS_USUARIO as tu
WHERE 	u.codigo_estado_cuenta = e.codigo_estado_cuenta AND
		u.codigo_tipo_usuario = tu.codigo_tipo_usuario; 

/*VISTA PARA MOSTRAR EL TOTAL DE LA ÓRDEN DE COMPRA*/
CREATE VIEW ORDER_SUMMARY AS 
SELECT oc.id_orden, oc.id_cliente, oc.fecha_compra, oc.codigo_estado_compra, SUM(oca.precio_base) 'Subtotales', SUM(oca.descuento_venta) 'Descuentos aplicados', SUM(oca.impuestos_venta) 'IVA aplicado' ,SUM(oca.precio_final) 'Total'
FROM ORDENES_COMPRA AS oc, ORDENES_COMPRA_HAS_ACCESORIOS AS oca
WHERE oc.id_orden = oca.id_orden
GROUP BY oca.id_orden; 

/*VISTA PARA MOSTAR LAS ÓRDENES DE COMPRA DE MANERA "FÁCIL DE ENTENDER"*/
CREATE OR REPLACE VIEW ORDER_SUMMARY_PRETTY AS
SELECT oc.id_orden, u1.nombre 'Nombre comprador', u2.nombre 'Nombre vendedor', DATE_FORMAT(oc.fecha_compra,"%e/%c/%Y %H:%i") 'fecha_compra', tec.estado_compra, SUM(oca.precio_base) 'Total Precios Base', SUM(oca.descuento_venta) 'Descuentos aplicados', SUM(oca.impuestos_venta) 'IVA aplicado' ,SUM(oca.precio_final) 'Total'
FROM (ORDENES_COMPRA AS oc, ORDENES_COMPRA_HAS_ACCESORIOS AS oca, TIPO_ESTADO_COMPRA AS tec)
LEFT JOIN USUARIOS AS u1 ON u1.id_usuario = oc.id_cliente
LEFT JOIN USUARIOS AS u2 ON u2.id_usuario = oc.id_vendedor
WHERE 	oc.id_orden = oca.id_orden AND
		oc.codigo_estado_compra = tec.codigo_estado_compra
GROUP BY oca.id_orden; 

/*VISTA PARA VER LOS ACCESORIOS DE LAS ÓRDENES DE COMPRA DE MANERA "FÁCIL DE ENTENDER"*/
CREATE VIEW BILL_DETAILS_PRETTY AS
SELECT oca.id_orden, a.nombre 'nombre_accesorio', oca.cantidad_venta 'cantidad_comprada', oca.precio_base, oca.descuento_venta 'descuento_aplicado', oca.impuestos_venta 'impuestos_aplicados', oca.precio_final
FROM ORDENES_COMPRA_HAS_ACCESORIOS as oca, ACCESORIOS as a
WHERE oca.id_accesorio = a.id_accesorio; 

/*VISTA PARA MOSTRAR LOS DATOS DE LA FACTURA DE MANERA "FÁCIL DE ENTENDER" */
CREATE OR REPLACE VIEW BILL_PRETTY AS
SELECT HF.id_factura, HF.id_orden, OC.fecha_compra, HF.productos, u1.nombre 'Nombre vendedor', u2.nombre 'Nombre cliente', u2.identificacion 'Cédula cliente', OSP.`Total Precios Base`, OSP.`Descuentos aplicados`, OSP.`IVA aplicado`, OSP.`Total`
FROM (HISTORICO_FACTURAS as HF, ORDENES_COMPRA as OC, ORDER_SUMMARY_PRETTY AS OSP)
LEFT JOIN USUARIOS AS u1 ON u1.id_usuario = OC.id_vendedor 
LEFT JOIN USUARIOS AS u2 ON u2.id_usuario = OC.id_cliente
WHERE 	OC.id_orden = HF.id_orden
GROUP BY HF.id_factura; 


/*VISTA PARA MOSTRAR LOS LOGS DE MANERA "FÁCIL DE ENTENDER"*/
DROP VIEW IF EXISTS LOGS_PRETTY;
CREATE VIEW LOGS_PRETTY AS
SELECT L.fecha_transaccion, JSON_PRETTY(L.estado_anterior) 'Estado anterior', JSON_PRETTY(L.estado_nuevo) 'Estado actual', TT.tipo_transaccion, TB.tabla 'Cambio en', u.nombre 'Responsable' 
FROM (LOGS as L, TIPOS_TRANSACCION as TT, TABLAS_EXISTENTES as TB)
LEFT JOIN USUARIOS AS u ON u.id_usuario = L.id_usuario_responsable
WHERE 	L.codigo_tipo_transaccion = TT.codigo_tipo_transaccion AND
		L.codigo_tabla_modificada = TB.codigo_tabla;

/*VISTA PARA EL MANEJO DEL CARRITO DE COMPRAS*/
DROP VIEW IF EXISTS CART_PRETTY; 
CREATE VIEW CART_PRETTY AS
SELECT cart.id_usuario, cart.id_accesorio, a.nombre, a.stock, a.precio_base, a.descuento, a.precio_final, a.ruta_imagen, cart.cantidad_accesorio
FROM CARRITO_COMPRAS AS cart, ACCESORIOS as a
WHERE cart.id_accesorio = a.id_accesorio; 