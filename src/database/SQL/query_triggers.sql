/* 
#######################################################
TRIGGERS PARA MANEJO DE CUENTAS DE USUARIO
#######################################################
*/

/* 
#######################################################
Trigger para registrar la creación de nuevas cuentas
Ok
#######################################################
*/

DELIMITER //

CREATE TRIGGER user_created AFTER INSERT ON USUARIOS
FOR EACH ROW
BEGIN 

	/*Si el usuario creó su cuenta, se añade él mismo como responsable de la creación y última modificación*/
	IF NEW.id_usuario_creacion IS NULL THEN
		SET @usuario_creacion = NEW.id_usuario; 
	ELSE
		SET @usuario_creacion = NEW.id_usuario_creacion; 
    END IF; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    @usuario_creacion,
    1,
    1, 
    JSON_OBJECT(
			"id_usuario", NEW.id_usuario, 
			"nombre", NEW.nombre, 
			"identificación", NEW.identificacion, 
			"correo_electrónico", NEW.correo_electronico, 
			"dirección", NEW.direccion, 
			"teléfono", NEW.telefono, 
			"aceptación_términos", NEW.aceptacion_terminos, 
			"contraseña", NEW.contraseña, 
			"código_tipo_usuario", NEW.codigo_tipo_usuario, 
			"código_estado_cuenta", NEW.codigo_estado_cuenta, 
			"id_usuario_creacion", NEW.id_usuario_creacion, 
			"id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
    ); 
    
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la modificación de un usuario
OK
#######################################################
*/

DELIMITER //

CREATE TRIGGER user_modified AFTER UPDATE ON USUARIOS
FOR EACH ROW
BEGIN 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
		-- el id del usuario responsable se toma de la variable @session_user_id
		NEW.id_usuario_ultima_modificacion,
		3,
		1, 
        JSON_OBJECT(
			"id_usuario", OLD.id_usuario, 
            "nombre", OLD.nombre, 
            "identificación", OLD.identificacion, 
			"correo_electrónico", OLD.correo_electronico, 
            "dirección", OLD.direccion, 
            "teléfono", OLD.telefono, 
            "aceptación_términos", OLD.aceptacion_terminos, 
            "contraseña", OLD.contraseña, 
            "código_tipo_usuario", OLD.codigo_tipo_usuario, 
            "código_estado_cuenta", OLD.codigo_estado_cuenta, 
			"id_usuario_creacion", OLD.id_usuario_creacion, 
			"id_usuario_ultima_modificacion", OLD.id_usuario_ultima_modificacion
        ), 
        JSON_OBJECT(
			"id_usuario", NEW.id_usuario, 
			"nombre", NEW.nombre, 
			"identificación", NEW.identificacion, 
			"correo_electrónico", NEW.correo_electronico, 
			"dirección", NEW.direccion, 
			"teléfono", NEW.telefono, 
			"aceptación_términos", NEW.aceptacion_terminos, 
			"contraseña", NEW.contraseña, 
			"código_tipo_usuario", NEW.codigo_tipo_usuario, 
			"código_estado_cuenta", NEW.codigo_estado_cuenta, 
			"id_usuario_creacion", NEW.id_usuario_creacion, 
			"id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
            )
	); 
    
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la eliminación de un usuario
PREGUNTAR SOBRE ESTE TRIGGER
#######################################################
*/

/*
DELIMITER //

CREATE TRIGGER user_removed AFTER DELETE ON USUARIOS
FOR EACH ROW
BEGIN 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior) 
    VALUES (
		@session_user_id, 
		4, 
		1, 
        JSON_OBJECT(
			"id_usuario", OLD.id_usuario, 
            "nombre", OLD.nombre, 
            "identificación", OLD.identificacion, 
			"correo_electrónico", OLD.correo_electronico, 
            "dirección", OLD.direccion, 
            "teléfono", OLD.telefono, 
            "aceptación_términos", OLD.aceptacion_terminos, 
            "contraseña", OLD.contraseña, 
            "código_tipo_usuario", OLD.codigo_tipo_usuario, 
            "código_estado_cuenta", OLD.codigo_estado_cuenta
        )
	); 
    
    SET @session_user_id = NULL; 

END //

DELIMITER ; 
*/

/* 
#######################################################
TRIGGERS PARA MANEJO DE ACCESORIO
#######################################################
*/

/* 
#######################################################
Trigger para registrar ingreso de accesorios (agrega el log y el historial de precios)
OK
#######################################################
*/

DELIMITER //

CREATE TRIGGER product_added AFTER INSERT ON ACCESORIOS
FOR EACH ROW
BEGIN 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    NEW.id_usuario_creacion,
    1,
    4,
    JSON_OBJECT(
    	"id_accesorio", NEW.id_accesorio,
		"is_active", NEW.is_active, 
		"nombre", NEW.nombre, 
		"descripcion", NEW.descripcion, 
		"stock", NEW.stock, 
		"precio_base", NEW.precio_base, 
		"descuento", NEW.descuento, 
		"unidades_vendidas", NEW.unidades_vendidas, 
		"id_usuario_creacion", NEW.id_usuario_creacion, 
		"id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
    ); 
    
    -- También se agrega el registro al histórico de precios
    INSERT INTO HISTORICO_CAMBIO_PRECIOS(precio_asignado, id_accesorio) VALUES (NEW.precio_base, NEW.id_accesorio); 
        
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la modificación de accesorios
OK
#######################################################
*/

DELIMITER //

CREATE TRIGGER product_modified AFTER UPDATE ON ACCESORIOS
FOR EACH ROW
BEGIN 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
		NEW.id_usuario_ultima_modificacion,
		3,
		4,
		JSON_OBJECT(
			"id_accesorio", OLD.id_accesorio,
			"is_active", OLD.is_active, 
			"nombre", OLD.nombre, 
			"descripcion", OLD.descripcion, 
			"stock", OLD.stock, 
			"precio_base", OLD.precio_base, 
			"descuento", OLD.descuento, 
			"unidades_vendidas", OLD.unidades_vendidas, 
			"id_usuario_creacion", OLD.id_usuario_creacion, 
			"id_usuario_ultima_modificacion", OLD.id_usuario_ultima_modificacion
		),
		JSON_OBJECT(
			"id_accesorio", NEW.id_accesorio,
			"is_active", NEW.is_active, 
			"nombre", NEW.nombre, 
			"descripcion", NEW.descripcion, 
			"stock", NEW.stock, 
			"precio_base", NEW.precio_base, 
			"descuento", NEW.descuento, 
			"unidades_vendidas", NEW.unidades_vendidas, 
			"id_usuario_creacion", NEW.id_usuario_creacion, 
			"id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
	); 
    
     -- Si el nuevo precio es diferente, se añade al histórico de precios
    IF OLD.precio_base != NEW.precio_base THEN 
		INSERT INTO HISTORICO_CAMBIO_PRECIOS(precio_asignado, id_accesorio) VALUES (NEW.precio_base, NEW.id_accesorio); 
	END IF;
        
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la eliminación de un accesorio
PREGUNTAR SOBRE ESTE TRIGGER
#######################################################
*/

/*
DELIMITER //

CREATE TRIGGER product_deleted AFTER DELETE ON ACCESORIOS
FOR EACH ROW
BEGIN 
	
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior) 
    VALUES (
		OLD.id_usuario_ultima_modificacion,
		4,
		4, 
		JSON_OBJECT(
			"id_accesorio", OLD.id_accesorio,
            "nombre", OLD.nombre, 
            "descripcion", OLD.descripcion, 
            "stock", OLD.stock, 
            "precio_base", OLD.precio_base, 
            "descuento", OLD.descuento, 
            "unidades_vendidas", OLD.unidades_vendidas)
	); 
    
    SET @session_user_id = NULL; 
    
END //

DELIMITER ; 
*/

/* 
#######################################################
TRIGGERS PARA MANEJO DE ÓRDENES DE COMPRA
#######################################################
*/

/* 
#######################################################
TRIGGERS PARA REGISTRAR LA CREACIÓN DE UNA ORDEN DE COMPRA
#######################################################
*/

DELIMITER //

CREATE TRIGGER order_added AFTER INSERT ON ORDENES_COMPRA
FOR EACH ROW
BEGIN 

    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    NEW.id_usuario_creacion,
    1,
    3,
    JSON_OBJECT(
    	"id_orden", NEW.id_orden, 
        "id_cliente", NEW.id_cliente, 
        "fecha_compra", NEW.fecha_compra, 
        "codigo_estado_compra", NEW.codigo_estado_compra, 
        "id_usuario_creacion", NEW.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
	); 
    
END //

DELIMITER ; 

/* 
#######################################################
TRIGGERS PARA REGISTRAR LA MODIFICACIÓN DE UNA ORDEN DE COMPRA
#######################################################
*/

DELIMITER //

CREATE TRIGGER order_modified AFTER UPDATE ON ORDENES_COMPRA
FOR EACH ROW
BEGIN 

    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
    NEW.id_usuario_ultima_modificacion,
    3,
    3,
    JSON_OBJECT(
    	"id_orden", OLD.id_orden, 
        "id_cliente", OLD.id_cliente, 
        "fecha_compra", OLD.fecha_compra, 
        "codigo_estado_compra", OLD.codigo_estado_compra, 
        "id_usuario_creacion", OLD.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", OLD.id_usuario_ultima_modificacion
		),
    JSON_OBJECT(
    	"id_orden", NEW.id_orden, 
        "id_cliente", NEW.id_cliente, 
        "fecha_compra", NEW.fecha_compra, 
        "codigo_estado_compra", NEW.codigo_estado_compra, 
        "id_usuario_creacion", NEW.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
	); 
    
END //

DELIMITER ; 


/* 
#######################################################
TRIGGERS PARA REGISTRAR LA CREACIÓN DE UN RESGISTRO EN LA TABLA ORDENES_COMPRA_HAS_ACCESORIOS
#######################################################
*/

DELIMITER //

CREATE TRIGGER ORDENES_COMPRA_HAS_ACCESORIOS_entry_added AFTER INSERT ON ORDENES_COMPRA_HAS_ACCESORIOS
FOR EACH ROW
BEGIN 

	INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    NEW.id_usuario_creacion,
    1,
    6,
    JSON_OBJECT(
    	"id_orden", NEW.id_orden, 
		"id_accesorio", NEW.id_accesorio, 
        "cantidad_venta", NEW.cantidad_venta, 
        "precio_base", NEW.precio_base, 
        "descuento", NEW.descuento_venta, 
        "impuestos_venta", NEW.impuestos_venta, 
        "precio_final", NEW.precio_final, 
        "id_usuario_creacion", NEW.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
	); 

END //

DELIMITER ;

/* 
#######################################################
TRIGGERS PARA REGISTRAR LA MODIFICACIÓN DE UN REGISTRO EN LA TABLA ORDENES_COMPRA_HAS_ACCESORIOS
#######################################################
*/

DELIMITER //

CREATE TRIGGER ORDENES_COMPRA_HAS_ACCESORIOS_entry_modified AFTER UPDATE ON ORDENES_COMPRA_HAS_ACCESORIOS
FOR EACH ROW
BEGIN 

    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
    NEW.id_usuario_ultima_modificacion,
    3,
    6,
    JSON_OBJECT(
    	"id_orden", OLD.id_orden, 
		"id_accesorio", OLD.id_accesorio, 
        "cantidad_venta", OLD.cantidad_venta, 
        "precio_base", OLD.precio_base, 
        "descuento", OLD.descuento_venta, 
        "impuestos_venta", OLD.impuestos_venta, 
        "precio_final", OLD.precio_final, 
        "id_usuario_creacion", OLD.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", OLD.id_usuario_ultima_modificacion
		),
    JSON_OBJECT(
    	"id_orden", NEW.id_orden, 
		"id_accesorio", NEW.id_accesorio, 
        "cantidad_venta", NEW.cantidad_venta, 
        "precio_base", NEW.precio_base, 
        "descuento", NEW.descuento_venta, 
        "impuestos_venta", NEW.impuestos_venta, 
        "precio_final", NEW.precio_final, 
        "id_usuario_creacion", NEW.id_usuario_creacion, 
        "id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
		)
	); 
    
END //

DELIMITER ; 

/* 
#######################################################
TRIGGERS PARA MANEJO DE MENSAJES ENVIADOS POR EL FORMULARIO
#######################################################
*/

/* 
#######################################################
Trigger para registrar la modificación del estado del mensaje
Ok
#######################################################
*/

DELIMITER //

CREATE TRIGGER message_status_modified AFTER UPDATE ON MENSAJES_INQUIETUDES
FOR EACH ROW
BEGIN 

	-- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
		NEW.id_usuario_ultima_modificacion, 
		3, 
		2, 
        JSON_OBJECT(
			"id_mensaje", OLD.id_mensaje, 
            "nombre_remitente", OLD.nombre_remitente, 
            "correo_remitente", OLD.correo_remitente, 
            "texto_mensaje", OLD.texto_mensaje, 
            "codigo_estado_mensaje", OLD.codigo_estado_mensaje, 
            "id_usuario_ultima_modificacion", OLD.id_usuario_ultima_modificacion
        ), 
        JSON_OBJECT(
			"id_mensaje", NEW.id_mensaje, 
            "nombre_remitente", NEW.nombre_remitente, 
            "correo_remitente", NEW.correo_remitente, 
            "texto_mensaje", NEW.texto_mensaje, 
            "codigo_estado_mensaje", NEW.codigo_estado_mensaje, 
            "id_usuario_ultima_modificacion", NEW.id_usuario_ultima_modificacion
        )
	); 
    
END //

DELIMITER ; 




