/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE CUENTAS DE USUARIO
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTO PARA LA CREACIÓN DE UN NUEVO USUARIO
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
	SET @session_user_id = null; 

	INSERT INTO USUARIOS(nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña) VALUES (nombre, identificacion, correo_electronico, direccion, telefono, aceptacion_terminos, contraseña); 
END //

DELIMITER ; 

/*
CALL REGISTER_NEW_CLIENT(
	"Pedro Andrés Chaparro Quintero", 
    "1005542142", 
    "pedroandreschaparro@gmail.com", 
    "Cll 1C #720-420 Cañaveral", 
    "6557895", 
    1, 
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

	SET @session_user_id = session_user_id; 

	UPDATE USUARIOS SET 
		USUARIOS.correo_electronico = correo_electronico, 
        USUARIOS.direccion = direccion, 
        USUARIOS.telefono = telefono, 
        USUARIOS.contraseña = contraseña 
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
#######################################################
*/

DELIMITER //

CREATE PROCEDURE CHANGE_EXISTING_USER_STATUS(
	session_user_id INT UNSIGNED, 
	id_usuario INT UNSIGNED, 
    estado_cuenta VARCHAR(32)
)
BEGIN 
	SET @session_user_id = session_user_id; 

	SELECT codigo_estado_cuenta INTO @codigo_estado_cuenta FROM TIPOS_ESTADO_CUENTA WHERE TIPOS_ESTADO_CUENTA.estado_cuenta = estado_cuenta; 
    
    UPDATE USUARIOS SET 
		USUARIOS.codigo_estado_cuenta = @codigo_estado_cuenta
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
#######################################################
*/

DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_ID(
	user_id INT UNSIGNED
)
BEGIN 
	SELECT * FROM SESSION_USER_DATA WHERE id_usuario = user_id; 
END //

DELIMITER ; 

-- CALL GET_USER_SESSION_DATA_FROM_ID(1); 

/* 
#######################################################
PROCEDIMIENTO PARA OBTENER LOS DATOS DE LA SESIÓN DEL USUARIO A PARTIR DEL CORREO
#######################################################
*/

DELIMITER //

CREATE PROCEDURE GET_USER_SESSION_DATA_FROM_MAIL(
	correo_electronico VARCHAR(255)
)
BEGIN 
	SELECT * FROM SESSION_USER_DATA WHERE correo_electronico = correo_electronico; 
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
    SET @session_user_id = session_user_id; 

	-- Se calcula el precio final a partir del precio base y el descuento 
	SET @precio_final = precio_base - (precio_base*descuento)/100; 
    -- Se escribe la ruta de la imagen a partir del nombre del accesorio
    SET @ruta_imagen = CONCAT(CONCAT('/', REPLACE(nombre, ' ', '_')), '.jpg'); 
    -- Se inserntan los datos. 
	INSERT INTO ACCESORIOS(nombre, descripcion, stock, precio_base, descuento, precio_final, ruta_imagen) VALUES (nombre, descripcion, stock, precio_base, descuento, @precio_final, @ruta_imagen); 
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
#######################################################
*/

DELIMITER //

CREATE PROCEDURE UPDATE_EXISTING_ACCESSORY(
	session_user_id INT UNSIGNED, 
	id_accesorio INT UNSIGNED, 
    nombre VARCHAR(64), 
    descripcion VARCHAR(324), 
    precio_base DECIMAL(12,2), 
    descuento TINYINT UNSIGNED
)
BEGIN 

	SET @session_user_id = session_user_id; 

	-- Se calcula el precio final a partir del precio base y el descuento 
	SET @precio_final = precio_base - (precio_base*descuento)/100; 
    -- Se escribe la ruta de la imagen a partir del nombre del accesorio
    SET @ruta_imagen = CONCAT(CONCAT('/', REPLACE(nombre, ' ', '_')), '.jpg'); 
    
	UPDATE ACCESORIOS SET 
		ACCESORIOS.nombre = nombre, 
        ACCESORIOS.descripcion = descripcion, 
        ACCESORIOS.precio_base = precio_base, 
        ACCESORIOS.descuento = descuento, 
        ACCESORIOS.precio_final = @precio_final, 
        ACCESORIOS.ruta_imagen = @ruta_imagen
	WHERE ACCESORIOS.id_accesorio = id_accesorio; 
    
END //

DELIMITER ;

/* 
#######################################################
PROCEDIMIENTO PARA AGREGAR INVENTARIO DE UN PRODUCTO EXISTENTE
#######################################################
*/

DELIMITER //

CREATE PROCEDURE ADD_INVENTORY_TO_EXISTING_ACCESSORY(
	session_user_id INT UNSIGNED, 
	id_accesorio INT UNSIGNED, 
    new_units INT UNSIGNED
)
BEGIN 
	
    SET @session_user_id = session_user_id; 
    
    UPDATE ACCESORIOS SET 
		ACCESORIOS.stock = ACCESORIOS.stock + new_units
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
PROCEDIMIENTOS PARA MANEJO DE ÓRDENES DE COMPRA
#######################################################
*/

/* 
#######################################################
PROCEDIMIENTOS PARA MANEJO DE MENSAJES DE CLIENTES (MENSAJES DEL FORMULARIO)
#######################################################
*/

DELIMITER //

CREATE PROCEDURE REGISTER_NEW_MESSAGE(
    texto_mensaje VARCHAR(324),
    id_usuario INT UNSIGNED
)
BEGIN 
	
    INSERT INTO MENSAJES_INQUIETUDES(texto_mensaje, id_usuario) VALUES (texto_mensaje, id_usuario); 
    
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
#######################################################
*/

DELIMITER //

CREATE PROCEDURE MARK_MESSAGE_AS_RESOLVED(
	session_user_id INT UNSIGNED, 
    id_mensaje INT UNSIGNED
)
BEGIN 
	
    SET @session_user_id = session_user_id; 
    
    -- Select "Resuelto" status_code
    SELECT codigo_estado_mensaje INTO @codigo_resuelto FROM TIPO_ESTADO_MENSAJE WHERE TIPO_ESTADO_MENSAJE.estado_mensaje = 'Resuelto'; 
    
	UPDATE MENSAJES_INQUIETUDES SET 
		MENSAJES_INQUIETUDES.codigo_estado_mensaje = @codigo_resuelto
	WHERE MENSAJES_INQUIETUDES.id_mensaje = id_mensaje; 
    
END //

DELIMITER ;

/*
CALL MARK_MESSAGE_AS_RESOLVED(
	2, 
	1
);  
*/