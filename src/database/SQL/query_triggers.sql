/* 
#######################################################
TRIGGERS PARA MANEJO DE ACCESORIO
Por ahora sin manejo del responsable
#######################################################
*/

/* 
#######################################################
Trigger para registrar ingreso de accesorios (agrega el log y el historial de precios)
#######################################################
*/

DELIMITER //

CREATE TRIGGER product_added AFTER INSERT ON ACCESORIOS
FOR EACH ROW
BEGIN 

	-- SELECCIONA EL CÓDIGO DE LA TABLA ACCESORIOS
	SELECT codigo_tabla INTO @id_tabla_accesorios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'ACCESORIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN INSERT
    SELECT codigo_tipo_transaccion INTO @id_insert FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Insert'; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    @session_user_id, 
    @id_insert, 
    @id_tabla_accesorios, 
    JSON_OBJECT(
			"id_accesorio", NEW.id_accesorio,
            "nombre", NEW.nombre, 
            "descripcion", NEW.descripcion, 
            "stock", NEW.stock, 
            "precio_base", NEW.precio_base, 
            "descuento", NEW.descuento, 
            "unidades_vendidas", NEW.unidades_vendidas
            )
    ); 
    
    -- También se agrega el registro al histórico de precios
    INSERT INTO HISTORICO_CAMBIO_PRECIOS(precio_asignado, id_accesorio) VALUES (NEW.precio_base, NEW.id_accesorio); 
    
    -- Se resetea el id de la sesión al terminar
    SET @session_user_id = NULL; 
    
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la modificación de accesorios
#######################################################
*/

DELIMITER //

CREATE TRIGGER product_modified AFTER UPDATE ON ACCESORIOS
FOR EACH ROW
BEGIN 

	-- SELECCIONA EL CÓDIGO DE LA TABLA ACCESORIOS
	SELECT codigo_tabla INTO @id_tabla_accesorios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'ACCESORIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN UPDATE
    SELECT codigo_tipo_transaccion INTO @id_update FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Update'; 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
		@session_user_id, 
		@id_update, 
		@id_tabla_accesorios, 
		JSON_OBJECT(
			"id_accesorio", OLD.id_accesorio,
            "nombre", OLD.nombre, 
            "descripcion", OLD.descripcion, 
            "stock", OLD.stock, 
            "precio_base", OLD.precio_base, 
            "descuento", OLD.descuento, 
            "unidades_vendidas", OLD.unidades_vendidas
            ),
		JSON_OBJECT(
			"id_accesorio", NEW.id_accesorio,
            "nombre", NEW.nombre, 
            "descripcion", NEW.descripcion, 
            "stock", NEW.stock, 
            "precio_base", NEW.precio_base, 
            "descuento", NEW.descuento, 
            "unidades_vendidas", NEW.unidades_vendidas
            )
	); 
    
     -- Si el nuevo precio es diferente, se añade al histórico de precios
    IF OLD.precio_base != NEW.precio_base THEN 
		INSERT INTO HISTORICO_CAMBIO_PRECIOS(precio_asignado, id_accesorio) VALUES (NEW.precio_base, NEW.id_accesorio); 
	END IF;
    
    SET @session_user_id = NULL; 
    
END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la eliminación de un accesorio
#######################################################
*/

DELIMITER //

CREATE TRIGGER product_deleted AFTER DELETE ON ACCESORIOS
FOR EACH ROW
BEGIN 
	
    -- SELECCIONA EL CÓDIGO DE LA TABLA ACCESORIOS
	SELECT codigo_tabla INTO @id_tabla_accesorios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'ACCESORIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN delete
    SELECT codigo_tipo_transaccion INTO @id_delete FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Delete'; 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior) 
    VALUES (
		@session_user_id, 
		@id_delete, 
		@id_tabla_accesorios, 
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

/* 
#######################################################
TRIGGERS PARA MENAJO DE CUENTAS DE USUARIO
Por ahora sin manejo del responsable
#######################################################
*/

/* 
#######################################################
Trigger para registrar la creación de nuevas cuentas
#######################################################
*/

DELIMITER //

CREATE TRIGGER user_created AFTER INSERT ON USUARIOS
FOR EACH ROW
BEGIN 

	-- SELECCIONA EL CÓDIGO DE LA TABLA USUARIOS
	SELECT codigo_tabla INTO @id_tabla_usuarios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'USUARIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN INSERT
    SELECT codigo_tipo_transaccion INTO @id_insert FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Insert'; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_nuevo) 
    VALUES (
    @session_user_id,
    @id_insert, 
    @id_tabla_usuarios,
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
            "código_estado_cuenta", NEW.codigo_estado_cuenta
            )
    ); 
    
    SET @session_user_id = NULL; 

END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la modificación de un usuario
#######################################################
*/

DELIMITER //

CREATE TRIGGER user_modified AFTER UPDATE ON USUARIOS
FOR EACH ROW
BEGIN 

	-- SELECCIONA EL CÓDIGO DE LA TABLA USUARIOS
	SELECT codigo_tabla INTO @id_tabla_usuarios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'USUARIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN UPDATE
    SELECT codigo_tipo_transaccion INTO @id_update FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Update'; 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior, estado_nuevo) 
    VALUES (
		-- el id del usuario responsable se toma de la variable @session_user_id
		@session_user_id,
		@id_update, 
		@id_tabla_usuarios, 
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
            "código_estado_cuenta", NEW.codigo_estado_cuenta
            )
	); 
    
    SET @session_user_id = NULL; 

END //

DELIMITER ; 

/* 
#######################################################
Trigger para registrar la eliminación de un usuario
#######################################################
*/

DELIMITER //

CREATE TRIGGER user_removed AFTER DELETE ON USUARIOS
FOR EACH ROW
BEGIN 

	-- SELECCIONA EL CÓDIGO DE LA TABLA USUARIOS
	SELECT codigo_tabla INTO @id_tabla_usuarios FROM TABLAS_EXISTENTES WHERE TABLAS_EXISTENTES.tabla = 'USUARIOS'; 
    
    -- SELECCIONA EL CÓDIGO DE LA TRANSACCIÓN UPDATE
    SELECT codigo_tipo_transaccion INTO @id_delete FROM TIPOS_TRANSACCION WHERE TIPOS_TRANSACCION.tipo_transaccion = 'Delete'; 
    
    -- Guardar el log
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada, estado_anterior) 
    VALUES (
		@session_user_id, 
		@id_delete, 
		@id_tabla_usuarios, 
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




