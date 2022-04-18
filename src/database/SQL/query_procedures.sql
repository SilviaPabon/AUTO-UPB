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
	/*Inserta el usuario*/
	INSERT INTO USUARIOS(nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña) VALUES (nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña); 
    
    /*Regresa el id del nuevo usuario*/
    SELECT id_usuario from USUARIOS where USUARIOS.correo_electronico = correo_electronico; 
END //

DELIMITER ; 

/*
CALL REGISTER_NEW_CLIENT(
	"Pedro Andrés Chaparro", 
    "1004251780", 
    "pedroaaaa@upb.edu.co", 
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
*/


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
PROCEDIMIENTO PARA LA SABER SU UN USUARIO YA EXISTE A PARTIR DEL DOCUMENTO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS USER_EXIST_FROM_DOCUMENT; 
DELIMITER //

CREATE PROCEDURE USER_EXIST_FROM_DOCUMENT(
	IN documento VARCHAR(24)
)
BEGIN 
	SELECT COUNT(*) 'CONTEO' FROM USUARIOS
    WHERE USUARIOS.identificacion = documento; 
END //

DELIMITER ; 

-- CALL USER_EXIST_FROM_DOCUMENT('1004251788'); 

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER LA CONTRASEÑA DEL USUARIO A PARTIR DE SU ID
#######################################################
*/
DROP PROCEDURE IF EXISTS GET_USER_PASSWORD; 
DELIMITER //

CREATE PROCEDURE GET_USER_PASSWORD(
	IN correo_electronico VARCHAR(255)
)
BEGIN
	
    SELECT contraseña FROM SESSION_USER_DATA 
    WHERE SESSION_USER_DATA.correo_electronico = correo_electronico; 
    
END// 

DELIMITER ; 

/*
CALL GET_USER_PASSWORD('carlos@upb.edu.co'); 
*/

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
	SELECT id_usuario, nombre, correo_electronico, codigo_tipo_usuario, codigo_estado_cuenta FROM SESSION_USER_DATA WHERE SESSION_USER_DATA.id_usuario = user_id; 
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
	SELECT id_usuario, nombre, correo_electronico, codigo_tipo_usuario, codigo_estado_cuenta FROM SESSION_USER_DATA WHERE UPPER(SESSION_USER_DATA.correo_electronico) = UPPER(correo_electronico); 
END //

DELIMITER ; 

-- CALL GET_USER_SESSION_DATA_FROM_MAIL('carlos@upb.edu.co'); 

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER TODOS LOS DATOS DE UN USUARIO A PARTIR DE SU ID
(PARA LA ACTUALIZACIÓN DE DATOS)
#######################################################
*/

DROP PROCEDURE IF EXISTS GET_USER_DATA_FROM_ID
DELIMITER //

CREATE PROCEDURE GET_USER_DATA_FROM_ID(
	IN session_user_id INT UNSIGNED
)
BEGIN

	SELECT nombre, identificacion, correo_electronico, direccion, telefono FROM USUARIOS
    WHERE USUARIOS.id_usuario = session_user_id; 
    
END //

DELIMITER ; 


/* 
#######################################################
PROCEDIMIENTO PARA CREACIÓN DE CUENTA POR PARTE DE ADMIN
#######################################################
*/

DELIMITER //

CREATE PROCEDURE ADMIN_CREATE_ACCOUNT(
	session_user_id INT UNSIGNED, 
    nombre VARCHAR(255),
    identificacion VARCHAR(24) ,
    correo_electronico VARCHAR(255),
    direccion VARCHAR(255) ,
    telefono VARCHAR(12) ,
    contraseña VARCHAR(255) ,
    codigo_tipo_usuario TINYINT(1) UNSIGNED
)
BEGIN 

	INSERT INTO USUARIOS(nombre, identificacion, correo_electronico, direccion, telefono, contraseña, codigo_tipo_usuario, aceptacion_terminos, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES (nombre, identificacion, correo_electronico, direccion, telefono, contraseña, codigo_tipo_usuario, 1, session_user_id, session_user_id); 
END //

DELIMITER ; 

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR AL ADMINISTRADOR LAS CUENTAS EXISTENTES
#######################################################
*/

DROP PROCEDURE IF EXISTS ADMIN_SHOW_ACCOUNTS; 
DELIMITER //

CREATE PROCEDURE ADMIN_SHOW_ACCOUNTS(
	IN session_user_id INT UNSIGNED
)
BEGIN 
	SELECT id_usuario, nombre, identificacion, correo_electronico, estado_cuenta
    FROM USERS_PRETTY; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 1);
END //

DELIMITER ; 

/*
CALL ADMIN_SHOW_ACCOUNTS(1); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR USUARIOS A ADMIN Y ANEXAR LOGS
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCOUNT_DETAILS; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCOUNT_DETAILS(
	IN id_usuario INT UNSIGNED,
    IN session_user_id INT UNSIGNED
)
BEGIN
	SELECT id_usuario, nombre, identificacion, telefono, correo_electronico, direccion, tipo_usuario, estado_cuenta
	FROM USERS_PRETTY 
	WHERE 
		id_usuario = USERS_PRETTY.id_usuario;
        
	INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 1);
END //
DELIMITER ;

/* 
CALL SHOW_ACCOUNT_DETAILS(
	2, 3
);
*/

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR USUARIOS A UN SOCIO, SOLO QUIENES ACEPTARON TÉRMINOS, ANEXAR LOGS
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCOUNTS_PARTNERS; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCOUNTS_PARTNERS(
	IN session_user_id INT UNSIGNED
)
BEGIN
	SELECT id_usuario, nombre, identificacion, telefono, correo_electronico, direccion
	FROM USERS_PRETTY 
	WHERE 
		aceptacion_terminos = 1
        AND tipo_usuario = "Cliente"
        AND estado_cuenta = "Activo";
        
	INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 1);
END //
DELIMITER ;

/*
CALL SHOW_ACCOUNTS_PARTNERS(
	1
);
*/

/*
#######################################################
PROCEDIMIENTO PARA QUE UN ADMINISTRADOR PUEDA BUSCAR UN USUARIO A PARTIR DE UN CRITERIO DADO
#######################################################
*/

DROP PROCEDURE IF EXISTS ADMIN_SEARCH_USER_FROM_CRITERIA; 
DELIMITER //

CREATE PROCEDURE ADMIN_SEARCH_USER_FROM_CRITERIA(
	IN session_user_id INT UNSIGNED,
	IN criteria VARCHAR(255)
) 
BEGIN 

	SELECT id_usuario, nombre, identificacion, correo_electronico, estado_cuenta FROM USERS_PRETTY
    WHERE UPPER(USERS_PRETTY.nombre) LIKE (CONCAT(UPPER(criteria), '%')) OR
		UPPER(USERS_PRETTY.correo_electronico) LIKE (CONCAT(UPPER(criteria), '%')) OR 
		USERS_PRETTY.identificacion LIKE (CONCAT(criteria, '%')); 
        
	INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 1);

END//

DELIMITER ; 

/*
CALL ADMIN_SEARCH_USER_FROM_CRITERIA(1, 'C'); 
*/

/*
#######################################################
PROCEDIMIENTO PARA QUE UN SOCIO PUEDA BUSCAR UN USUARIO A PARTIR DE UN CRITERIO DADO
#######################################################
*/

DROP PROCEDURE IF EXISTS PARTNER_SEARCH_USER_FROM_CRITERIA; 
DELIMITER //

CREATE PROCEDURE PARTNER_SEARCH_USER_FROM_CRITERIA(
	IN session_user_id INT UNSIGNED,
	IN criteria VARCHAR(255)
) 
BEGIN 

	SELECT id_usuario, nombre, identificacion, telefono, correo_electronico, direccion
	FROM USERS_PRETTY 
	WHERE 
		aceptacion_terminos = 1 AND
		tipo_usuario = "Cliente" AND
		estado_cuenta = "Activo" AND
        (
        UPPER(USERS_PRETTY.nombre) LIKE (CONCAT(UPPER(criteria), '%')) OR
		UPPER(USERS_PRETTY.correo_electronico) LIKE (CONCAT(UPPER(criteria), '%')) OR 
		USERS_PRETTY.identificacion LIKE (CONCAT(criteria, '%'))
        ); 
        
	INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 1);

END//

DELIMITER ;  

/*
CALL PARTNER_SEARCH_USER_FROM_CRITERIA(1, 'J'); 
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE INVENTARIO
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA COMPROBAR SI YA EXISTE UN ACCESORIO
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS ACCESSORY_EXIST; 
DELIMITER //

CREATE PROCEDURE ACCESSORY_EXIST(
	IN nombre VARCHAR(255)
)
BEGIN 
    	SELECT COUNT(*) 'CONTEO' FROM ACCESORIOS
    	WHERE UPPER(ACCESORIOS.nombre) = UPPER(nombre); 
END //

DELIMITER ; 

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
    IN precio_compra DECIMAL(12,2), 
    IN precio_base DECIMAL(12,2), 
    IN descuento TINYINT UNSIGNED
)
BEGIN 

	-- Se calcula el precio final a partir del precio base y el descuento 
	SET @precio_final = precio_base - (precio_base*descuento)/100; 
    -- Se escribe la ruta de la imagen a partir del nombre del accesorio
    SET @ruta_imagen = CONCAT(CONCAT('/', REPLACE(nombre, ' ', '_')), '.jpg'); 
    -- Se inserntan los datos. 
	INSERT INTO ACCESORIOS(nombre, descripcion, stock, precio_ultima_compra, precio_base, descuento, precio_final, ruta_imagen, id_usuario_creacion, id_usuario_ultima_modificacion)
    VALUES (nombre, 
			descripcion, 
            stock, 
            precio_compra, 
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
    1600000,
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
    IN precio_compra DECIMAL(12,2), 
    IN new_units INT UNSIGNED
)
BEGIN 

    UPDATE ACCESORIOS SET 
		ACCESORIOS.stock = ACCESORIOS.stock + new_units, 
        ACCESORIOS.id_usuario_ultima_modificacion = session_user_id, 
        ACCESORIOS.precio_ultima_compra = precio_compra
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;


/*
CALL ADD_INVENTORY_TO_EXISTING_ACCESSORY(
	1, 
	15, 
    1600000, 
    6
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
PROCEDIMIENTOS PARA MOSTRAR LOS ACCESORIOS EXISTENTES A CUALQUIER USUARIO
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
PROCEDIMIENTOS PARA MOSTRAR AL PERSONAL INTERNO LOS ACCESORIOS EXISTENTES 
Y GENERAL LOG
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCESSORIES_INTERNAL; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCESSORIES_INTERNAL(
	IN session_user_id INT UNSIGNED
)
BEGIN 
	/*SELECCIÓN A MOSTRAR*/
	SELECT id_accesorio, nombre, stock, precio_final 
    FROM ACCESORIOS 
    WHERE is_active = 1; 
    
    /*REGISTRO DEL LOG DE LA CONSULTA*/
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 4);
    
END//

DELIMITER ; 

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR AL ADMIN LOS ACCESORIOS EXISTENTES ACTIVOS E INACTIVOS
Y GENERAR LOG
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCESSORIES_ADMIN; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCESSORIES_ADMIN(
    IN session_user_id INT UNSIGNED
)
BEGIN 

	SELECT id_accesorio, nombre, is_active, precio_final, ruta_imagen
    FROM ACCESORIOS; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 4);

END// 

DELIMITER ; 

/* 
#######################################################
PROCEDIMIENTOS PARA QUE EL PERSONAL INTERNO PUEDA BUSCAR ACCESORIOS (SOCIO Y TRABAJADORES) 
Y GENERAL LOG
#######################################################
*/

DROP PROCEDURE IF EXISTS SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL; 

DELIMITER //

CREATE PROCEDURE SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL(	
	IN session_user_id INT UNSIGNED,
	IN criteria VARCHAR(255)
)
BEGIN 
	SELECT  id_accesorio, nombre, precio_final, stock FROM ACCESORIOS
    WHERE 	UPPER(ACCESORIOS.nombre) LIKE (CONCAT(UPPER(criteria), '%')) AND
			ACCESORIOS.is_active = 1; 

	/*REGISTRO DEL LOG DE LA CONSULTA*/
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 4);
END // 

/*
CALL SEARCH_ACCESSORIES_FROM_CRITERIA_INTERNAL(1, 'C');
*/

DROP PROCEDURE IF EXISTS SEARCH_ACCESSORIES_FROM_CRITERIA_ADMIN; 

DELIMITER //

CREATE PROCEDURE SEARCH_ACCESSORIES_FROM_CRITERIA_ADMIN(	
	IN session_user_id INT UNSIGNED,
	IN criteria VARCHAR(255)
)
BEGIN 
	SELECT   id_accesorio, nombre, is_active, precio_final, ruta_imagen FROM ACCESORIOS
    WHERE 	UPPER(ACCESORIOS.nombre) LIKE (CONCAT(UPPER(criteria), '%')); 

	/*REGISTRO DEL LOG DE LA CONSULTA*/
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 4);
END //

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

	SELECT id_accesorio, nombre, stock, precio_base, descuento, precio_final, ruta_imagen
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

	SELECT id_accesorio, nombre, stock, precio_final, unidades_vendidas, ruta_imagen
    FROM ACCESORIOS 
    WHERE 
		is_active = 1 AND
        unidades_vendidas > 0
    ORDER BY unidades_vendidas DESC
    LIMIT 12; 
    

END// 

DELIMITER ;

/*
CALL SHOW_TOP_SALES(); 
*/

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

/*
CALL SHOW_ACCESSORY_DETAILS(3); 
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR LOS DETALLES DE UN ACCESORIO PARA ADMIN
#######################################################
*/

DROP PROCEDURE IF EXISTS SHOW_ACCESSORY_DETAILS_ADMIN; 
DELIMITER //

CREATE PROCEDURE SHOW_ACCESSORY_DETAILS_ADMIN(
	IN id_accesorio INT UNSIGNED
)
BEGIN 

	SELECT id_accesorio, nombre, is_active, descripcion, stock, precio_base, descuento, precio_final, unidades_vendidas, ruta_imagen
    FROM ACCESORIOS 
    WHERE 
        ACCESORIOS.id_accesorio = id_accesorio; 
        
END// 

DELIMITER ;

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE ÓRDENES DE COMPRA
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTOS PARA OBTENER DATOS DE UN USUARIO EXISTENTE PARA EL FORMULARIO DE LA
ORDEN DE COMPRA (DESDE LA CAJA).
OK
#######################################################
*/
DROP PROCEDURE IF EXISTS GET_USER_DATA_BUY_ORDER;
DELIMITER //

CREATE PROCEDURE GET_USER_DATA_BUY_ORDER(
	IN documento VARCHAR(24)
)
BEGIN 
	
    SELECT id_usuario, nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos 
    FROM USUARIOS
    WHERE USUARIOS.identificacion = documento; 
    
END //

DELIMITER ;   

/*
CALL GET_USER_DATA_BUY_ORDER('1004251788'); 
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

	/*CREA EL REGISTRO DE LA ORDEN DE COMPRA*/
	IF session_user_id != id_cliente THEN
		INSERT INTO ORDENES_COMPRA(id_cliente, id_vendedor, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES(id_cliente, session_user_id, session_user_id, session_user_id); 
    ELSE
		INSERT INTO ORDENES_COMPRA(id_cliente, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES(id_cliente, session_user_id, session_user_id); 
    END IF;
    
    /*REGRESA EL ID DE LA ORDEN DE COMPRA*/
    SELECT id_orden, fecha_compra FROM ORDENES_COMPRA
    WHERE ORDENES_COMPRA.id_cliente = id_cliente
	ORDER BY fecha_compra DESC
    LIMIT 1; 
    
    
END //

DELIMITER ; 

/*
CALL REGISTER_NEW_BUY_ORDER(
	1, 
    1
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA VER EL HISTÓRICO DE PRECIOS DE UN PRODUCTO
#######################################################
*/

DROP PROCEDURE IF EXISTS HISTORICAL_ACCESSORY_PRICES; 

DELIMITER //

CREATE PROCEDURE HISTORICAL_ACCESSORY_PRICES(
	IN session_user_id INT UNSIGNED,
    IN id_accesorio INT UNSIGNED 
)
BEGIN 
    
	SELECT nombre_accesorio, precio_asignado, fecha_cambio, u_responsable
        FROM HISTORIAL_PRICES_VIEW AS H 
        WHERE
        H.id_accesorio = id_accesorio; 
	
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 9);

END //

DELIMITER ; 

/*
CALL HISTORICAL_ACCESSORY_PRICES(1, 56); 
SELECT * FROM LOGS;
*/

/* 
#######################################################
PROCEDIMIENTOS PARA ASOCIAR LOS ACCESORIOS CON LA ORDEN DE COMPRA
Se usa una transacción para asegurarse de que todos los accesorios son agregados
correctamente
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS register_buy_order_from_cart; 

DELIMITER //

CREATE PROCEDURE register_buy_order_from_cart
(
	IN session_user_id INT UNSIGNED,
    IN buy_order_id INT UNSIGNED
)
BEGIN     
    -- Creación de la condición de parada
    DECLARE done INT DEFAULT FALSE; 
    
    -- Creación de las variables usadas por el cursor
    DECLARE accessory_id, accessory_amount, accessory_disscount INT; 
    DECLARE accessory_base_price, accessory_final_price DECIMAL(12,2); 
    
    -- Creación del cursor
    DECLARE cart_cursor CURSOR FOR 
		SELECT id_accesorio, precio_base, descuento, precio_final, cantidad_accesorio FROM CART_PRETTY
        WHERE 	CART_PRETTY.id_usuario = session_user_id; 

    -- Creación del handler para la condición de parada
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Creación del handler por si algo sale mal
    DECLARE EXIT HANDLER FOR sqlexception
    BEGIN
    
		/*Elimina la orden de compra, ya que fue fallida*/
        CALL REMOVE_BUY_ORDER(session_user_id, buy_order_id); 
    
		/*Si algo sale mal muestra informaciónd el accesorio en el que falló*/
		SELECT id_accesorio, nombre, stock FROM ACCESORIOS 
		WHERE ACCESORIOS.id_accesorio = accessory_id; 
		ROLLBACK;
        
    END;
		 
        
	-- Evitar que la base de datos haga commits de las etapas de la transacción
	SET autocommit = 0; 
    
	START TRANSACTION; 
    
        -- Inicializa el cursor
		OPEN cart_cursor; 
		
		-- Loop para iterar el carrito y añadir a la orden de compra
		
		order_loop: LOOP 
			FETCH cart_cursor INTO accessory_id, accessory_base_price, accessory_disscount, accessory_final_price, accessory_amount; 
			
			IF done THEN 
				LEAVE order_loop; 
			END IF;
			
			-- Variables para facilitar cálculos
			SET @base_price_amount = accessory_base_price * accessory_amount; 
			SET @disscount_amount = ((accessory_base_price * accessory_disscount)/100) * accessory_amount; 
			SET @taxes_amount = (@base_price_amount - @disscount_amount)*0.19; 
			SET @final_price_amount = @base_price_amount - @disscount_amount + @taxes_amount; 
            			
			-- Resta el accesorio de la tabla de inventario
            UPDATE ACCESORIOS
            SET 	ACCESORIOS.stock = ACCESORIOS.stock - accessory_amount, 
					ACCESORIOS.unidades_vendidas = ACCESORIOS.unidades_vendidas + accessory_amount, 
                    ACCESORIOS.id_usuario_ultima_modificacion = session_user_id
			WHERE ACCESORIOS.id_accesorio = accessory_id; 
			
			-- Añade el accesorio a la orden de compra
			INSERT INTO ORDENES_COMPRA_HAS_ACCESORIOS (
			id_orden, 
			id_accesorio, 
			cantidad_venta, 
			precio_base,
			descuento_venta, 
			impuestos_venta, 
			precio_final, 
			id_usuario_creacion, 
			id_usuario_ultima_modificacion) VALUES (
				buy_order_id, 
				accessory_id,
				accessory_amount, 
				@base_price_amount, 
				@disscount_amount, 
				@taxes_amount, 
				@final_price_amount,
				session_user_id, 
				session_user_id
			); 
					
		END LOOP;
		CLOSE cart_cursor; 
        
        -- Vacía el carrito de compras
        DELETE FROM CARRITO_COMPRAS 
        WHERE CARRITO_COMPRAS.id_usuario = session_user_id; 
        
        -- Crea la factura
        CALL facture_add(session_user_id, buy_order_id); 
        
    COMMIT; 
    
    SET autocommit = 1; 
    
END//

DELIMITER ; 

/*
SELECT * FROM CARRITO_COMPRAS; 
CALL register_buy_order_from_cart(1, 1); 
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
PROCEDIMIENTOS PARA ELIMINAR UNA ORDEN DE COMPRA
OK
#######################################################
*/

DROP PROCEDURE IF EXISTS REMOVE_BUY_ORDER; 
DELIMITER //

CREATE PROCEDURE REMOVE_BUY_ORDER(
	IN session_user_id INT UNSIGNED,
	IN order_id INT UNSIGNED
)
BEGIN 

	/* ACTUALIZA EL CAMPO DE ÚLTIMA MODIFICACIÓN PARA EL REGISTRO DEL LOG */
	UPDATE ORDENES_COMPRA 
    SET id_usuario_ultima_modificacion = session_user_id
    WHERE ORDENES_COMPRA.id_orden = order_id; 
    
    
    /*REALIZA LA ELIMINACIÓN DE LA ORDEN*/
	DELETE FROM ORDENES_COMPRA
    WHERE ORDENES_COMPRA.id_orden = order_id;
    
    
END //

DELIMITER ; 

/*
CALL REGISTER_NEW_BUY_ORDER(
	1, 
    1
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR ORDENES DE COMPRA POR ID CLIENTE
#######################################################
*/
DROP PROCEDURE IF EXISTS GET_USER_ORDERBUY_FROM_ID;
DELIMITER //

CREATE PROCEDURE GET_USER_ORDERBUY_FROM_ID(
	IN session_user_id INT UNSIGNED
)
BEGIN
	    
    /*Tomar los datos de la orden*/
    SELECT id_orden, estado_compra, fecha_compra, `Total Precios Base`, `Descuentos aplicados`, `IVA aplicado`, Total
	FROM ORDER_SUMMARY_PRETTY AS OSP
	WHERE OSP.`Codigo comprador` = session_user_id; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 3);
    
END //

DELIMITER ; 

/*
CALL GET_USER_ORDERBUY_FROM_ID(
	1
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR ORDENES DE COMPRA DE TODOS LOS CLIENTES
#######################################################
*/
DROP PROCEDURE IF EXISTS GETALL_USER_ORDERBUY;
DELIMITER //

CREATE PROCEDURE GETALL_USER_ORDERBUY(
	IN session_user_id INT UNSIGNED
)
BEGIN
	
    SELECT id_orden, `Nombre comprador`, `Nombre vendedor`, fecha_compra, estado_compra, `Total Precios Base`, `Descuentos aplicados`, `IVA aplicado`, `Total`
	FROM order_summary_pretty AS OSP; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 3);
    
END //

DELIMITER ;
BEGIN
	
    SELECT id_orden, codigo_estado_compra, fecha_compra, Subtotales, `Descuentos aplicados`, `IVA aplicado`, Total
	FROM ORDER_SUMMARY AS OS; 
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 3);
    
END //

DELIMITER ; 

/*
CALL GETALL_USER_ORDERBUY(
	1
);
*/

/* 
#######################################################
PROCEDIMIENTO PARA MOSTRAR ORDENES DE COMPRA A PARTIR DEL NOMBRE
#######################################################
*/
DROP PROCEDURE IF EXISTS GET_USER_ORDERBUY_FROM_NAME;
DELIMITER //

CREATE PROCEDURE GET_USER_ORDERBUY_FROM_NAME(
	IN nombre VARCHAR(255),
	IN session_user_id INT UNSIGNED
)
BEGIN
	
    SELECT id_orden, codigo_estado_compra, fecha_compra, Subtotales, `Descuentos aplicados`, `IVA aplicado`, Total
	FROM ORDER_SUMMARY AS OS, USUARIOS
	WHERE USUARIOS.id_usuario = OS.id_cliente 
    AND USUARIOS.nombre = nombre;
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 3);
    
END //

DELIMITER ;

/* 
CALL GET_USER_ORDERBUY_FROM_NAME('Pedro Andrés Chaparro', 1);  
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
	IN session_user_id INT UNSIGNED,
	IN id_orden INT UNSIGNED
)
BEGIN 
    
    /*Insertar el JSON en la tabla de facturas*/
    INSERT INTO HISTORICO_FACTURAS(id_orden, productos, id_usuario_creacion, id_usuario_ultima_modificacion) VALUES (
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
		WHERE BILL_DETAILS_PRETTY.id_orden = id_orden), 
        session_user_id, 
        session_user_id
	);
    
    /*Genera el log*/
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 1, 7);
 
END//

DELIMITER ;

/*
CALL facture_add(3, 1); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER LA INFORMACIÓN DE UNA FACTURA
#######################################################
*/

DROP PROCEDURE IF EXISTS get_bill_details_from_id; 
DELIMITER //

CREATE PROCEDURE get_bill_details_from_id(
	IN session_user_id INT UNSIGNED, 
    IN id_orden INT UNSIGNED
)
BEGIN

	/*Selecciona los datos de la orden pasada como parámetro*/
	SELECT * FROM BILL_PRETTY 
		WHERE BILL_PRETTY.id_orden = id_orden; 

	/*Genera los logs*/
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 7);

END //

DELIMITER ; 

/*
CALL get_bill_details_from_id(1, 1); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER EL ID DEL "DUEÑO" DE LA ORDEN DE COMPRA
#######################################################
*/

DROP PROCEDURE IF EXISTS get_buy_order_owner; 
DELIMITER //

CREATE PROCEDURE get_buy_order_owner(
    IN id_orden INT UNSIGNED
)
BEGIN

	/*Selecciona los datos de la orden pasada como parámetro*/
	SELECT `Codigo comprador` FROM ORDER_SUMMARY_PRETTY 
		WHERE ORDER_SUMMARY_PRETTY.id_orden = id_orden; 

END //

DELIMITER ;

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

/* 
#######################################################
PROCEDIMIENTOS PARA MOSTRAR TODOS LOS MENSAJES DEL FORMULARIO)
#######################################################
*/

DROP PROCEDURE IF EXISTS GETALL_MESSAGES;
DELIMITER //

CREATE PROCEDURE GETALL_MESSAGES(
	IN session_user_id INT UNSIGNED
)
BEGIN
	
    SELECT nombre_remitente, correo_remitente, texto_mensaje
    FROM MENSAJES_INQUIETUDES
    ORDER BY codigo_estado_mensaje;
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 2);
    
END //

DELIMITER ; 

/* CALL GETALL_MESSAGES(1); */

/* 
#######################################################
PROCEDIMIENTOS PARA EL MANEJO DEL CARRITO DE COMPRAS
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA AÑADIR UN ELEMENTO AL CARRITO
#######################################################
*/

DROP PROCEDURE IF EXISTS ADD_ACCESSORY_CART; 

DELIMITER //

CREATE PROCEDURE ADD_ACCESSORY_CART(
	IN session_user_id INT UNSIGNED,
    IN id_accesorio INT UNSIGNED
)
BEGIN 

	SET @success = 0; 

	/*Revisa si el accesorio ya existe*/
    SELECT COUNT(*) INTO @count_exists FROM CARRITO_COMPRAS 
	WHERE 	CARRITO_COMPRAS.id_usuario = session_user_id AND
			CARRITO_COMPRAS.id_accesorio = id_accesorio; 
            
	/*Almacena la MÁXIMA CANTIDAD a partir del STOCK del accesorio*/
	SELECT ACCESORIOS.stock into @maxAllowed
        FROM ACCESORIOS WHERE
        ACCESORIOS.id_accesorio = id_accesorio; 
	
    /*Procede según si existe el accesorio en el carrito o no*/
    IF @count_exists = 0 THEN 
		/*Si no existe y hay sufiente stock lo agrega*/
        IF @maxAllowed >= 1 THEN 
			INSERT INTO CARRITO_COMPRAS(id_usuario, id_accesorio, cantidad_accesorio)
			VALUES(session_user_id, id_accesorio, 1); 
            SET @success = 1; 
        END IF; 
    ELSE
		/*Si existe revisa que haya sufiente stock para agregar una unidad*/
        SELECT cart.cantidad_accesorio into @actualAmount
		FROM CARRITO_COMPRAS as cart WHERE
        cart.id_usuario = session_user_id AND
        cart.id_accesorio = id_accesorio; 
        
        IF @maxAllowed > @actualAmount THEN
			UPDATE CARRITO_COMPRAS
			SET cantidad_accesorio = cantidad_accesorio + 1
			WHERE 	CARRITO_COMPRAS.id_usuario = session_user_id AND
					CARRITO_COMPRAS.id_accesorio = id_accesorio; 
			SET @success = 1; 
        END IF;
        
    END IF; 
    
    SELECT @success; 

END //

DELIMITER ; 

/*
CALL ADD_ACCESSORY_CART(1, 28); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA MODIFICAR LA CANTIDAD DE UN ACCESORIO EN EL CARRITO
#######################################################
*/

DROP PROCEDURE IF EXISTS MODIFY_AMOUNT_ACCESSORY_CART; 

DELIMITER //

CREATE PROCEDURE MODIFY_AMOUNT_ACCESSORY_CART(
	IN session_user_id INT UNSIGNED,
    IN id_accesorio INT UNSIGNED, 
    IN amount INT UNSIGNED
)
BEGIN 
	
	/*Almacena la MÁXIMA CANTIDAD a partir del STOCK del accesorio*/
	SELECT CART_PRETTY.stock into @maxAllowed
        FROM CART_PRETTY WHERE
        CART_PRETTY.id_usuario = session_user_id AND
        CART_PRETTY.id_accesorio = id_accesorio; 
	
    /*Si hay suficiente stock, resaliza el cambio*/
    IF @maxAllowed >= amount THEN 
		/*Asigna al accesorio en el carrito la cantidad pasada como argumento*/
		UPDATE CARRITO_COMPRAS
		SET cantidad_accesorio = amount
		WHERE 	CARRITO_COMPRAS.id_usuario = session_user_id AND
				CARRITO_COMPRAS.id_accesorio = id_accesorio; 
    END IF; 

END //

DELIMITER ; 

/*
CALL MODIFY_AMOUNT_ACCESSORY_CART(1, 28, 10); 
SELECT * FROM CART_PRETTY; 
UPDATE CART_PRETTY SET cantidad_accesorio = 11 WHERE id_accesorio = 28; 
*/

/* 
#######################################################
PROCEDIMIENTO PARA ELIMINAR UN ACCESORIO DEL CARRITO DE COMPRAS
#######################################################
*/

DROP PROCEDURE IF EXISTS REMOVE_ACCESSORY_CART; 

DELIMITER //

CREATE PROCEDURE REMOVE_ACCESSORY_CART(
	IN session_user_id INT UNSIGNED,
    IN id_accesorio INT UNSIGNED
)
BEGIN 
	
    /*Eliminar el accesorio del usuario según el id de ambos*/
	DELETE FROM CARRITO_COMPRAS
	WHERE 	CARRITO_COMPRAS.id_usuario = session_user_id AND
			CARRITO_COMPRAS.id_accesorio = id_accesorio; 

END //

DELIMITER ; 

/*
CALL REMOVE_ACCESSORY_CART(1,15); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER EL CARRITO DE COMPRAS DE UN USUARIO
#######################################################
*/

DROP PROCEDURE IF EXISTS GET_ACCESSORY_CART; 

DELIMITER //

CREATE PROCEDURE GET_ACCESSORY_CART(
	IN session_user_id INT UNSIGNED
)
BEGIN 
	
    SELECT * FROM CART_PRETTY 
    WHERE CART_PRETTY.id_usuario = session_user_id; 

END //

DELIMITER ; 

/*
CALL GET_ACCESSORY_CART(1); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER INFO DE ORDEN DE COMPRA SEGÚN SU ID
#######################################################
*/

DROP PROCEDURE IF EXISTS GET_ORDERBUY_ID; 

DELIMITER //

CREATE PROCEDURE GET_ORDERBUY_ID(
	IN id_orden INT UNSIGNED
)
BEGIN 
	
    SELECT OA.id_accesorio, nombre, cantidad_venta, DATE_FORMAT(fecha_compra,"%e/%c/%Y %H:%i") AS fecha_compra, OA.precio_final 
    FROM ordenes_compra_has_accesorios AS OA, ordenes_compra AS OC, accesorios AS A
    WHERE OA.id_orden = id_orden
    AND OC.id_orden = id_orden
    AND A.id_accesorio = OA.id_accesorio
    AND OC.codigo_estado_compra = 2; 

END //

DELIMITER ; 

/*
CALL GET_ORDERBUY_ID(3); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA ACTUALIZAR EL INVENTARIO LUEGO DE UNA DEVOLUCIÓN
#######################################################
*/

DROP PROCEDURE IF EXISTS UPDATE_INVENTORY_FROM_REFUNDS; 
DELIMITER //

CREATE PROCEDURE UPDATE_INVENTORY_FROM_REFUNDS(
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
#######################################################
PROCEDIMIENTOS DE MOVIMIENTOS/RENDIMIENTOS FINANCIEROS
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA ACTUALIZAR LAS GANANCIAS LUEGO DE UNA DEVOLUCIÓN
#######################################################
*/

DROP PROCEDURE IF EXISTS UPDATE_PROFITS_FROM_REFUNDS; 
DELIMITER //

CREATE PROCEDURE UPDATE_PROFITS_FROM_REFUNDS(
	IN session_user_id INT UNSIGNED,  
    IN update_profits INT UNSIGNED
)
BEGIN 

    INSERT INTO HISTORICO_INGRESOS_GASTOS SET 
        HISTORICO_INGRESOS_GASTOS.codigo_tipo_movimiento = 3, 
        HISTORICO_INGRESOS_GASTOS.valor_movimiento = update_profits, 
	    HISTORICO_INGRESOS_GASTOS.id_usuario_creacion = session_user_id, 
    HISTORICO_INGRESOS_GASTOS.id_usuario_ultima_modificacion = session_user_id;
    
END //

DELIMITER ;

/* 
#######################################################
PROCEDIMIENTO PARA VISUALIZAR LOS INGRESOS
#######################################################
*/

DROP PROCEDURE IF EXISTS VISUALIZE_PROFITS_ADMIN; 
DELIMITER //

CREATE PROCEDURE VISUALIZE_PROFITS_ADMIN(
	IN session_user_id INT UNSIGNED
)
BEGIN 
    SELECT fecha_movimiento, tipo_movimiento, valor, usuario_responsable
		FROM PROFITS_OUTGOINGS_VIEW
		WHERE codigo_movimiento = 1;
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 8);
    
END //

DELIMITER ;

/*CALL VISUALIZE_PROFITS_ADMIN(1);*/

/* 
#######################################################
PROCEDIMIENTO PARA VISUALIZAR LOS GASTOS
#######################################################
*/

DROP PROCEDURE IF EXISTS VISUALIZE_OUTGOINGS_ADMIN; 
DELIMITER //

CREATE PROCEDURE VISUALIZE_OUTGOINGS_ADMIN(
	IN session_user_id INT UNSIGNED
)
BEGIN 

    SELECT fecha_movimiento, tipo_movimiento, valor, usuario_responsable
		FROM PROFITS_OUTGOINGS_VIEW
		WHERE (codigo_movimiento = 2 OR codigo_movimiento = 3);
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 8);
    
END //

DELIMITER ;

/*CALL VISUALIZE_OUTGOINGS_ADMIN(1);*/

/* 
#######################################################
PROCEDIMIENTO PARA VISUALIZAR LAS ENTRADAS O GASTOS
#######################################################
*/

DROP PROCEDURE IF EXISTS VISUALIZE_RESUME_ADMIN; 
DELIMITER //

CREATE PROCEDURE VISUALIZE_RESUME_ADMIN(
	IN session_user_id INT UNSIGNED
)
BEGIN 

    -- Se suma el valor de las entradas
	SET @entradas = (SELECT SUM(valor)
					FROM PROFITS_OUTGOINGS_VIEW
					WHERE codigo_movimiento = 1);
    -- Se suma el valor de las pérdidas
    SET @gastos =  (SELECT SUM(valor)
					FROM PROFITS_OUTGOINGS_VIEW
					WHERE codigo_movimiento = 2 OR codigo_movimiento = 3);
                    
	SELECT ROUND((@entradas - @gastos), 2) AS resumen FROM PROFITS_OUTGOINGS_VIEW
    GROUP BY resumen;
    
    INSERT INTO LOGS(id_usuario_responsable, codigo_tipo_transaccion, codigo_tabla_modificada) 
    VALUES (session_user_id, 2, 8);
    
END //

DELIMITER ;

/*CALL VISUALIZE_RESUME_ADMIN(1);*/

/* 
#######################################################
PROCEDIMIENTO PARA VALIDAR SI SE PUEDE HACER LA DEVOLUCIÓN
#######################################################
*/

DROP PROCEDURE IF EXISTS OBTAIN_CURRENT_REFUNDS; 

DELIMITER //

CREATE PROCEDURE OBTAIN_CURRENT_REFUNDS(
	IN id_orden INT UNSIGNED, 
    IN id_accesorio INT UNSIGNED, 
    IN cantidad INT UNSIGNED
) 
BEGIN

	SELECT SUM(cantidad_devuelta) 'currentRefunds' FROM HISTORICO_DEVOLUCIONES AS HD
    WHERE 	HD.id_orden = id_orden AND
			HD.id_accesorio = id_accesorio; 
    
END//

DELIMITER ;

/* 
#######################################################
PROCEDIMIENTO PARA REGISTRAR UNA NUEVA DEVOLUCIÓN
#######################################################
*/

DROP PROCEDURE IF EXISTS REGISTER_REFUND; 

DELIMITER //

CREATE PROCEDURE REGISTER_REFUND(
	IN id_orden INT UNSIGNED, 
    IN id_accesorio INT UNSIGNED, 
    IN cantidad INT UNSIGNED, 
    IN session_user_id INT UNSIGNED
)
BEGIN

	INSERT INTO HISTORICO_DEVOLUCIONES (id_orden, id_accesorio, cantidad_devuelta, id_responsable_devolucion) 
    VALUES (id_orden, id_accesorio, cantidad, session_user_id); 

END //

DELIMITER ;