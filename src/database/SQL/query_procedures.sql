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

DELIMITER //

CREATE PROCEDURE REGISTER_NEW_CLIENT(
    nombre VARCHAR(255),
    identificacion VARCHAR(24) ,
    correo_electronico VARCHAR(255),
    direccion VARCHAR(255) ,
    telefono VARCHAR(12) ,
    aceptacion_terminos TINYINT(1) UNSIGNED,  
    contraseña VARCHAR(255)
)
BEGIN 
	INSERT INTO USUARIOS(nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña) VALUES (nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña); 
END //

DELIMITER ; 

/*
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
*/


/* 
#######################################################
PROCEDIMIENTO PARA LA MODIFICACIÓN DE UN USUARIO
OK
#######################################################
*/

DELIMITER //

CREATE PROCEDURE UPDATE_EXISTING_USER(
	-- id del usuario que tiene sesión en la aplicación para tomar el id del responsable del cambio
	session_user_id INT UNSIGNED, 
	id_usuario INT UNSIGNED, 
    correo_electronico VARCHAR(255),
    direccion VARCHAR(255) ,
    telefono VARCHAR(12) ,
    contraseña VARCHAR(255) 
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

DELIMITER //

CREATE PROCEDURE CHANGE_EXISTING_USER_STATUS(
	session_user_id INT UNSIGNED, 
	id_usuario INT UNSIGNED, 
    estado_cuenta VARCHAR(32)
)
BEGIN 

	SELECT codigo_estado_cuenta INTO @codigo_estado_cuenta FROM TIPOS_ESTADO_CUENTA WHERE TIPOS_ESTADO_CUENTA.estado_cuenta = estado_cuenta; 
    
    UPDATE USUARIOS SET 
		USUARIOS.codigo_estado_cuenta = @codigo_estado_cuenta, 
        USUARIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE USUARIOS.id_usuario = id_usuario; 
    
END //

DELIMITER ; 

/*
CALL CHANGE_EXISTING_USER_STATUS(
	2, 
	1, 
    "Fuera de servicio"
); 
*/

/* 
#######################################################
PROCEDIMIENTO PARA LA SABER SU UN USUARIO YA EXISTE
OK
#######################################################
*/

DELIMITER //

CREATE PROCEDURE USER_EXIST(
	correo_electronico VARCHAR(255)
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

DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_ID(
	user_id INT UNSIGNED
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

DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_MAIL(
	correo_electronico VARCHAR(255)
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

DELIMITER //

CREATE PROCEDURE ADD_NEW_ACCESSORY(
	session_user_id INT UNSIGNED, 
	nombre VARCHAR(64), 
    descripcion VARCHAR(324), 
    stock INT UNSIGNED,
    precio_base DECIMAL(12,2), 
    descuento TINYINT UNSIGNED
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

DELIMITER //

CREATE PROCEDURE UPDATE_EXISTING_ACCESSORY(
	session_user_id INT UNSIGNED, 
	id_accesorio INT UNSIGNED, 
    is_active TINYINT(1) UNSIGNED, 
    nombre VARCHAR(64), 
    descripcion VARCHAR(324), 
    precio_base DECIMAL(12,2), 
    descuento TINYINT UNSIGNED
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
#######################################################
PROCEDIMIENTO PARA AGREGAR INVENTARIO DE UN PRODUCTO EXISTENTE
OK
#######################################################
*/

DELIMITER //

CREATE PROCEDURE ADD_INVENTORY_TO_EXISTING_ACCESSORY(
	session_user_id INT UNSIGNED, 
	id_accesorio INT UNSIGNED, 
    new_units INT UNSIGNED
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
	2, 
    15
);  
*/

/* 
#######################################################
PROCEDIMIENTO PARA CAMBIAR EL ESTADO DE UN ACCESORIO
0: False/inactivo 1:True/activo
OK
#######################################################
*/

DELIMITER //

CREATE PROCEDURE CHANGE_ACCESSORY_STATUS(
	session_user_id INT UNSIGNED, 
	id_accesorio INT UNSIGNED, 
    is_active TINYINT(1) UNSIGNED
)
BEGIN 

    UPDATE ACCESORIOS SET 
		ACCESORIOS.is_active = is_active, 
        ACCESORIOS.id_usuario_ultima_modificacion = session_user_id
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE ÓRDENES DE COMPRA
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE MENSAJES DE CLIENTES (MENSAJES DEL FORMULARIO)
OK
#######################################################
*/

DELIMITER //

CREATE PROCEDURE REGISTER_NEW_MESSAGE(
	nombre_usuario VARCHAR(255), 
    correo_usuario VARCHAR(255), 
    texto_mensaje VARCHAR(324)
)
BEGIN 

    INSERT INTO MENSAJES_INQUIETUDES(nombre_remitente, correo_remitente, texto_mensaje) VALUES (nombre_usuario, correo_usuario, texto_mensaje); 
    
END //

DELIMITER ;

/*
CALL REGISTER_NEW_MESSAGE(
	"Hola", 
    2
);  
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO MARCAR UN MENSAJE COMO RESUELTO
Ok
#######################################################
*/

DELIMITER //

CREATE PROCEDURE MARK_MESSAGE_AS_RESOLVED(
	session_user_id INT UNSIGNED, 
    id_mensaje INT UNSIGNED
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