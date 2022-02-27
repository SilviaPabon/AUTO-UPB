/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE CUENTAS DE USUARIO
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA LA CREACIÓN DE UN NUEVO USUARIO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS REGISTER_NEW_CLIENT; 
DELIMITER //

CREATE PROCEDURE REGISTER_NEW_CLIENT(
    IN nombre VARCHAR(255),
    IN identificacion VARCHAR(24) ,
    IN correo_electronico VARCHAR(255),
    IN direccion VARCHAR(255) ,
    IN telefono VARCHAR(12) ,
    IN aceptacion_terminos TINYINT(1) UNSIGNED,  
    IN contraseña VARCHAR(255)
)
BEGIN 
	INSERT INTO USUARIOS(nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña) VALUES (nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña); 
END //

DELIMITER ; 


CALL REGISTER_NEW_CLIENT(
	"Pedro Andrés Chaparro", 
    "1004251788", 
    "pedro@upb.edu.co", 
    "Cll 1C #720-440 Piedecuesta", 
    "3147852233", 
    0, 
    "password"
);

CALL REGISTER_NEW_CLIENT(
	"Carlos Humberto Gomez", 
    "37845963", 
    "carlos@upb.edu.co", 
    "Cll 1C #720-440 Bucaramanga", 
    "3114578542", 
    0, 
    "password"
);

CALL REGISTER_NEW_CLIENT(
	"Daniela Alejandra Hernández", 
    "1004578521", 
    "aleja@gmail.com", 
    "Cll 1C #720-440 Cañaveral", 
    "3225478652", 
    1, 
    "passsssssss"
); 



/* 
#######################################################
PROCEDIMIENTO PARA LA MODIFICACIÓN DE UN USUARIO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS UPDATE_EXISTING_USER; 
DELIMITER //

CREATE PROCEDURE UPDATE_EXISTING_USER(
	IN session_user_id INT UNSIGNED, 
	IN id_usuario INT UNSIGNED, 
    IN correo_electronico VARCHAR(255),
    IN direccion VARCHAR(255) ,
    IN telefono VARCHAR(12) ,
    IN contraseña VARCHAR(255) 
)
BEGIN 

	UPDATE USUARIOS SET 
		USUARIOS.correo_electronico = correo_electronico, 
        USUARIOS.direccion = direccion, 
        USUARIOS.telefono = telefono, 
        USUARIOS.contraseña = contraseña, 
        USUARIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE USUARIOS.id_usuario = id_usuario; 
    
END //

DELIMITER ; 

/*
CALL UPDATE_EXISTING_USER(
	1, 
	1, 
    "pedroandreschaparro@hotmail.com", 
    "Cll 1C #720-420 Cañaveral", 
    "6557895", 
    "micontraseña"
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA LA MODIFICACIÓN DEL ESTADO DE CUENTA DE UN USUARIO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS CHANGE_EXISTING_USER_STATUS; 
DELIMITER //

CREATE PROCEDURE CHANGE_EXISTING_USER_STATUS(
	IN session_user_id INT UNSIGNED, 
	IN id_usuario INT UNSIGNED, 
    IN codigo_estado_cuenta INT UNSIGNED
)
BEGIN 
    
    UPDATE USUARIOS SET 
		USUARIOS.codigo_estado_cuenta = codigo_estado_cuenta, 
        USUARIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE USUARIOS.id_usuario = id_usuario; 
    
END //

DELIMITER ; 

/*
CALL CHANGE_EXISTING_USER_STATUS(
	2, 
	1, 
    3
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA LA SABER SU UN USUARIO YA EXISTE
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS USER_EXIST; 
DELIMITER //

CREATE PROCEDURE USER_EXIST(
	IN correo_electronico VARCHAR(255)
)
BEGIN 
	SELECT COUNT(*) 'CONTEO' FROM USUARIOS
    WHERE UPPER(USUARIOS.correo_electronico) = UPPER(correo_electronico); 
END //

DELIMITER ; 

-- CALL USER_EXIST('carlos@upb.edu.co'); 

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER LOS DATOS DE LA SESIÓN DEL USUARIO A PARTIR DEL ID
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS GET_USER_SESSION_DATA_FROM_ID; 
DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_ID(
	IN user_id INT UNSIGNED
)
BEGIN 
	SELECT * FROM SESSION_USER_DATA WHERE SESSION_USER_DATA.id_usuario = user_id; 
END //

DELIMITER ; 

-- CALL GET_USER_SESSION_DATA_FROM_ID(1); 

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER LOS DATOS DE LA SESIÓN DEL USUARIO A PARTIR DEL CORREO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS GET_USER_SESSION_DATA_FROM_MAIL; 
DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_MAIL(
	IN correo_electronico VARCHAR(255)
)
BEGIN 
	SELECT * FROM SESSION_USER_DATA WHERE SESSION_USER_DATA.correo_electronico = correo_electronico; 
END //

DELIMITER ; 

-- CALL GET_USER_SESSION_DATA_FROM_MAIL('carlos@upb.edu.co'); 

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE INVENTARIO
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA AGREGAR NUEVO PRODUCTO AL INVENTARIO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS ADD_NEW_ACCESSORY; 
DELIMITER //

CREATE PROCEDURE ADD_NEW_ACCESSORY(
	IN session_user_id INT UNSIGNED, 
	IN nombre VARCHAR(64), 
    IN descripcion VARCHAR(324), 
    IN stock INT UNSIGNED,
    IN precio_base DECIMAL(12,2), 
    IN descuento TINYINT UNSIGNED
)
BEGIN 

	-- Se calcula el precio final a partir del precio base y el descuento 
	SET @precio_final = precio_base - (precio_base*descuento)/100; 
    -- Se escribe la ruta de la imagen a partir del nombre del accesorio
    SET @ruta_imagen = CONCAT(CONCAT('/', REPLACE(nombre, ' ', '_')), '.jpg'); 
    -- Se inserntan los datos. 
	INSERT INTO ACCESORIOS(nombre, descripcion, stock, precio_base, descuento, precio_final, ruta_imagen, id_usuario_creacion, id_usuario_ultima_modificacion)
    VALUES (nombre, 
			descripcion, 
            stock, 
            precio_base, 
            descuento, 
            @precio_final, 
            @ruta_imagen, 
            session_user_id, 
            session_user_id
            ); 
    
END //

DELIMITER ; 

/*
CALL ADD_NEW_ACCESSORY(
	2, 
	"Rin cromado plateado 18in", 
	"Juego de 4 Rines de 18 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo.", 
	20, 
    2200000, 
    5
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MODIFICAR LOS DETALLES DE UN ACCESORIO EXISTENTE
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS UPDATE_EXISTING_ACCESSORY; 
DELIMITER //

CREATE PROCEDURE UPDATE_EXISTING_ACCESSORY(
	IN session_user_id INT UNSIGNED, 
	IN id_accesorio INT UNSIGNED, 
    IN is_active TINYINT(1) UNSIGNED, 
    IN nombre VARCHAR(64), 
    IN descripcion VARCHAR(324), 
    IN precio_base DECIMAL(12,2), 
    IN descuento TINYINT UNSIGNED
)
BEGIN 

	-- Se calcula el precio final a partir del precio base y el descuento 
	SET @precio_final = precio_base - (precio_base*descuento)/100; 
    -- Se escribe la ruta de la imagen a partir del nombre del accesorio
    SET @ruta_imagen = CONCAT(CONCAT('/', REPLACE(nombre, ' ', '_')), '.jpg'); 
    
	UPDATE ACCESORIOS SET 
		ACCESORIOS.is_active = is_active, 
		ACCESORIOS.nombre = nombre, 
        ACCESORIOS.descripcion = descripcion, 
        ACCESORIOS.precio_base = precio_base, 
        ACCESORIOS.descuento = descuento, 
        ACCESORIOS.precio_final = @precio_final, 
        ACCESORIOS.ruta_imagen = @ruta_imagen, 
        ACCESORIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;

/*
CALL UPDATE_EXISTING_ACCESSORY(
	3, 
    1, 
    1, 
    "Rines de lujo plateados cromados", 
    "Juego de 4 Rines de 18 pulgadas con cromado de aleación de aluminio de alta resistencia (color plateado). Proporciona frenadas más eficiente, mejora la refrigeración de los discos de frenado, protege las suspensión del vehículo y mejora la apariencia del vehículo.", 
    2600000, 
    28
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA AGREGAR INVENTARIO DE UN PRODUCTO EXISTENTE
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS ADD_INVENTORY_TO_EXISTING_ACCESSORY; 
DELIMITER //

CREATE PROCEDURE ADD_INVENTORY_TO_EXISTING_ACCESSORY(
	IN session_user_id INT UNSIGNED, 
	IN id_accesorio INT UNSIGNED, 
    IN new_units INT UNSIGNED
)
BEGIN 

    UPDATE ACCESORIOS SET 
		ACCESORIOS.stock = ACCESORIOS.stock + new_units, 
        ACCESORIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;


/*
CALL ADD_INVENTORY_TO_EXISTING_ACCESSORY(
	3, 
	1, 
    400
);  
*/

/* 
#######################################################
PROCEDIMIENTO PARA CAMBIAR EL ESTADO DE UN ACCESORIO
0: False/inactivo 1:True/activo
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS CHANGE_ACCESSORY_STATUS; 
DELIMITER //

CREATE PROCEDURE CHANGE_ACCESSORY_STATUS(
	IN session_user_id INT UNSIGNED, 
	IN id_accesorio INT UNSIGNED, 
    IN is_active TINYINT(1) UNSIGNED
)
BEGIN 

    UPDATE ACCESORIOS SET 
		ACCESORIOS.is_active = is_active, 
        ACCESORIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;

/*
CALL CHANGE_ACCESSORY_STATUS(
	2, 
    2, 
    0
); 
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR LOS ACCESORIOS EXISTENTES
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCESSORIES; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCESSORIES(

)
BEGIN 

	SELECT id_accesorio, nombre, stock, precio_final, ruta_imagen 
    FROM ACCESORIOS 
    WHERE is_active = 1; 
    

END// 

DELIMITER ;

/*
CALL SHOW_ACCESSORIES(); 
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR LOS 12 ACCESORIOS CON MÁS DESCUENTO
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_TOP_DISCOUNT; 
DELIMITER //

CREATE PROCEDURE SHOW_TOP_DISCOUNT(

)
BEGIN 

	SELECT id_accesorio, nombre, precio_base, descuento, precio_final, ruta_imagen
    FROM ACCESORIOS 
    WHERE 
		is_active = 1 AND 
		descuento > 0
    ORDER BY descuento DESC
    LIMIT 12; 
    

END// 

DELIMITER ;

/* CALL SHOW_TOP_DISCOUNT(); */

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR LOS 12 ACCESORIOS MÁS VENDIDOS
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_TOP_SALES; 
DELIMITER //

CREATE PROCEDURE SHOW_TOP_SALES(

)
BEGIN 

	SELECT id_accesorio, nombre, precio_final, unidades_vendidas, ruta_imagen
    FROM ACCESORIOS 
    WHERE 
		is_active = 1 AND
        unidades_vendidas > 0
    ORDER BY unidades_vendidas DESC
    LIMIT 12; 
    

END// 

DELIMITER ;

CALL SHOW_TOP_SALES(); 

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR LOS DETALLES DE UN ACCESORIO
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCESSORY_DETAILS; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCESSORY_DETAILS(
	IN id_accesorio INT UNSIGNED
)
BEGIN 

	SELECT id_accesorio, nombre, descripcion, stock, precio_base, descuento, precio_final, unidades_vendidas, ruta_imagen
    FROM ACCESORIOS 
    WHERE 
		is_active = 1 AND
        ACCESORIOS.id_accesorio = id_accesorio; 
        
END// 

DELIMITER ;

CALL SHOW_ACCESSORY_DETAILS(3); 

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE ÓRDENES DE COMPRA
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTOS PARA REGISTRAR UNA NUEVA ORDEN DE COMPRA
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS REGISTER_NEW_BUY_ORDER; 
DELIMITER //

CREATE PROCEDURE REGISTER_NEW_BUY_ORDER(
	IN session_user_id INT UNSIGNED,
	IN id_cliente INT UNSIGNED
)
BEGIN 

	IF session_user_id != id_cliente THEN
		INSERT INTO ORDENES_COMPRA(id_cliente, id_vendedor, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES(id_cliente, session_user_id, session_user_id, session_user_id); 
    ELSE
		INSERT INTO ORDENES_COMPRA(id_cliente, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES(id_cliente, session_user_id, session_user_id); 
    END IF;
    
END //

DELIMITER ; 

/*
CALL REGISTER_NEW_BUY_ORDER(
	3, 
    1
); 
*/


/* 
#######################################################
PROCEDIMIENTOS PARA RELACIONAR UN ACCESORIO CON LA ORDEN DE COMPRA
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS RELATE_ACCESSORIE_WITH_BUY_ORDER; 
DELIMITER //

CREATE PROCEDURE RELATE_ACCESSORIE_WITH_BUY_ORDER(
	IN session_user_id INT UNSIGNED,
    IN id_orden INT UNSIGNED, 
    IN id_accesorio INT UNSIGNED, 
    IN cantidad_venta SMALLINT UNSIGNED
)
BEGIN 

	/*SE OBTIENE EL PRECIO DEL ACCESORIO Y SU DESCUENTO AL MOMENTO DE LA VENTA*/
    SELECT precio_base, descuento INTO @precio_base, @descuento
    FROM ACCESORIOS 
    WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
    /*SE CALCULAN LOS PRECIOS TOTALES SEGÚN LA CANTIDAD COMPRADA*/
    SET @precio_base = @precio_base * cantidad_venta; 
    SET @descuento = ((@precio_base * @descuento)/100); 
    
    /*SE CALCULA EL IVA*/
    SET @taxes = (@precio_base - @descuento)*0.19; 
    SET @precio_final = @precio_base - @descuento + @taxes; 
    
    /*SE INSERTAN TODOS LOS DATOS EN LA TABLA DE LA RELACIÓN M-M*/
	INSERT INTO ORDENES_COMPRA_HAS_ACCESORIOS(id_orden, id_accesorio, cantidad_venta, precio_base, descuento_venta, impuestos_venta, precio_final, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES (
		id_orden, 
        id_accesorio, 
        cantidad_venta, 
        @precio_base, 
        @descuento, 
        @taxes, 
        @precio_final, 
        session_user_id, 
        session_user_id
    ); 
    
    /*SE RESETEAN LAS VARIABLES*/
    SET @precio_base = NULL; 
    SET @descuento = NULL; 
    SET @precio_final = NULL; 
    SET @taxes = NULL; 
    
END //

DELIMITER ; 

/*
CALL RELATE_ACCESSORIE_WITH_BUY_ORDER(
	3, 
    1, 
    1, 
    4
); 

CALL RELATE_ACCESSORIE_WITH_BUY_ORDER(
	3, 
    1,
    2, 
    3
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MARCAR ORDEN DE COMPRA COMO RECIBIDA
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS MARK_ORDER_AS_RECEIVED; 
DELIMITER //

CREATE PROCEDURE MARK_ORDER_AS_RECEIVED(
	IN session_user_id INT UNSIGNED,
	IN id_orden INT UNSIGNED
)
BEGIN 

	UPDATE ORDENES_COMPRA SET 
		ORDENES_COMPRA.codigo_estado_compra = 2, 
        ORDENES_COMPRA.id_usuario_ultima_modificacion = session_user_id
	WHERE ORDENES_COMPRA.id_orden = id_orden; 
    
END //

DELIMITER ; 

/*
CALL MARK_ORDER_AS_RECEIVED(
	1, 
    1
); 
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE FACTURAS
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA CREAR EL REGISTRO DE LA FACTURA LUEGO DE CREAR LA ÓRDEN DE COMPRA
#######################################################
*/

DROP PROCEDURE IF EXISTS facture_add; 
DELIMITER //

CREATE PROCEDURE facture_add(
	IN id_orden INT UNSIGNED
)
BEGIN 
    
    /*Insertar el JSON en la tabla de facturas*/
    INSERT INTO HISTORICO_FACTURAS(id_orden, productos) VALUES (
		id_orden, 
        (SELECT JSON_ARRAYAGG(JSON_OBJECT(
			"Accesorio", nombre_accesorio, 
			"Cantidad", cantidad_comprada, 
			"Precio Base", precio_base, 
			"Descuento Aplicado", descuento_aplicado, 
			"Impuestos Aplicados", impuestos_aplicados, 
			"Precio Final", precio_final
			))
		FROM BILL_DETAILS_PRETTY
		WHERE BILL_DETAILS_PRETTY.id_orden = id_orden)
	);
 
END//

DELIMITER ;

CALL facture_add(1); 

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE MENSAJES DE CLIENTES (MENSAJES DEL FORMULARIO)
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS REGISTER_NEW_MESSAGE; 
DELIMITER //

CREATE PROCEDURE REGISTER_NEW_MESSAGE(
	IN nombre_usuario VARCHAR(255), 
    IN correo_usuario VARCHAR(255), 
    IN texto_mensaje VARCHAR(324)
)
BEGIN 

    INSERT INTO MENSAJES_INQUIETUDES(nombre_remitente, correo_remitente, texto_mensaje) VALUES (nombre_usuario, correo_usuario, texto_mensaje); 
    
END //

DELIMITER ;

/*
CALL REGISTER_NEW_MESSAGE(
	"Carolina Gutierrez", 
    "caro@gmail.com", 
    "Hola, me comunico con ustedes para solicitar..."
);  
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO MARCAR UN MENSAJE COMO RESUELTO
Ok
#######################################################
*/

DROP PROCEDURE IF EXISTS MARK_MESSAGE_AS_RESOLVED; 
DELIMITER //

CREATE PROCEDURE MARK_MESSAGE_AS_RESOLVED(
	IN session_user_id INT UNSIGNED, 
    IN id_mensaje INT UNSIGNED
)
BEGIN 
	    
	UPDATE MENSAJES_INQUIETUDES SET 
		MENSAJES_INQUIETUDES.codigo_estado_mensaje = 2, 
        MENSAJES_INQUIETUDES.id_usuario_ultima_modificacion = session_user_id
	WHERE MENSAJES_INQUIETUDES.id_mensaje = id_mensaje; 
    
END //

DELIMITER ;

/*
CALL MARK_MESSAGE_AS_RESOLVED(
	2, 
	1
);  
*/