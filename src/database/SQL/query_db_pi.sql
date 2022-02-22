-- CREATE DATABASE PRUEBAS_PROYECTO_INTEGRADOR; 
-- USE PRUEBAS_PROYECTO_INTEGRADOR; 

CREATE TABLE TIPOS_USUARIO(
	codigo_tipo_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tipo_usuario VARCHAR(64) NOT NULL COMMENT 'El usuario puede ser administrador, trabajador, cliente o socio'
); 

CREATE TABLE TIPOS_ESTADO_CUENTA(
	codigo_estado_cuenta INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_cuenta VARCHAR(64) NOT NULL COMMENT 'La cuenta puede encontrarse activa, inactiva o fuera de servicio' 
); 

CREATE TABLE USUARIOS(
	id_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre VARCHAR(255) NOT NULL COMMENT 'Se almacena el nombre completo para las personas naturales y la razón social para las empresas del consorcio', 
    identificacion VARCHAR(24) NOT NULL UNIQUE COMMENT 'Se almacena la cédula o documento de identificación para las personas naturales y el NIT para las empresas del consorcio', 
    correo_electronico VARCHAR(255) NOT NULL UNIQUE, 
    direccion VARCHAR(255) NOT NULL, 
    telefono VARCHAR(12) NOT NULL, 
    aceptacion_terminos TINYINT(1) NOT NULL COMMENT 'Aceptación por parte del usuario del tratamiento de sus datos personales para beneficio de la empresa y el consorcio', 
    contraseña VARCHAR(255) NOT NULL, 
    codigo_tipo_usuario INT UNSIGNED NOT NULL DEFAULT 1,
    codigo_estado_cuenta INT UNSIGNED NOT NULL DEFAULT 1, 
    
    CONSTRAINT fk_usuarios_tipos_usuarios FOREIGN KEY (codigo_tipo_usuario) REFERENCES TIPOS_USUARIO(codigo_tipo_usuario), 
    CONSTRAINT fk_usuarios_tipos_estado_cuenta FOREIGN KEY (codigo_estado_cuenta) REFERENCES TIPOS_ESTADO_CUENTA(codigo_estado_cuenta),
    
    INDEX usuarios_nombre(nombre), 
    INDEX usuarios_correo_electronico(correo_electronico), 
    INDEX usuarios_id(id_usuario), 
    INDEX usuarios_codigo_tipo_usuaruio(codigo_tipo_usuario), 
    INDEX usuarios_codigo_estado_cuenta(codigo_estado_cuenta)
); 

CREATE TABLE TIPOS_TRANSACCION(
	codigo_tipo_transaccion INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tipo_transaccion VARCHAR(64) NOT NULL COMMENT 'El tipo de transacción guardada en los logs puede ser de Insert, Delete o Update'
); 

CREATE TABLE TABLAS_EXISTENTES(
	codigo_tabla INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    tabla VARCHAR(64) NOT NULL COMMENT 'Tablas existentes en la base de datos'
); 

CREATE TABLE LOGS(
	id_transaccion INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_transaccion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    estado_anterior JSON NULL DEFAULT NULL,
    estado_nuevo JSON NULL DEFAULT NULL, 
    codigo_tipo_transaccion INT UNSIGNED NOT NULL,
    codigo_tabla_modificada INT UNSIGNED NOT NULL, 
    id_usuario_responsable INT UNSIGNED NULL DEFAULT NULL,
    
    CONSTRAINT fk_logs_tipo_transaccion FOREIGN KEY (codigo_tipo_transaccion) REFERENCES TIPOS_TRANSACCION(codigo_tipo_transaccion), 
    CONSTRAINT fk_logs_tabla_modificada FOREIGN KEY (codigo_tabla_modificada) REFERENCES TABLAS_EXISTENTES(codigo_tabla),
    CONSTRAINT fk_logs_usuarios FOREIGN KEY (id_usuario_responsable) REFERENCES USUARIOS(id_usuario),
    
    INDEX logs_fecha_transaccion(fecha_transaccion), 
    INDEX logs_tipo_transaccion(codigo_tipo_transaccion), 
    INDEX logs_tabla_modificada(codigo_tabla_modificada)
); 

CREATE TABLE TIPO_ESTADO_MENSAJE(
	codigo_estado_mensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_mensaje VARCHAR(64) NOT NULL COMMENT 'El mensaje puede enviado o resuelto'
); 

CREATE TABLE MENSAJES_INQUIETUDES(
	id_mensaje INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    texto_mensaje VARCHAR(324) NOT NULL, 
    codigo_estado_mensaje INT UNSIGNED NOT NULL DEFAULT 1, 
    id_usuario INT UNSIGNED NOT NULL, 
    
    CONSTRAINT fk_mensajes_tipo_estado_mensaje FOREIGN KEY (codigo_estado_mensaje) REFERENCES TIPO_ESTADO_MENSAJE(codigo_estado_mensaje), 
    CONSTRAINT fk_mensajes_usuarios FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario)
); 


CREATE TABLE TIPO_ESTADO_COMPRA(
	codigo_estado_compra INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    estado_compra VARCHAR(64) NOT NULL COMMENT 'La orden de compra puede tener estado Enviada y Recibida'
); 

CREATE TABLE ACCESORIOS(
	id_accesorio INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    nombre VARCHAR(64) NOT NULL, 
    descripcion VARCHAR(324) NOT NULL, 
    stock INT UNSIGNED NOT NULL, 
    precio_base DECIMAL(12,2) NOT NULL COMMENT 'Precio inicial del artículo sin descuento', 
    descuento TINYINT UNSIGNED NOT NULL COMMENT 'Porcentaje actual de descuento', 
    precio_final DECIMAL(12,2) NOT NULL COMMENT 'Precio_base - precio_base*descuento', 
    unidades_vendidas INT UNSIGNED NULL DEFAULT 0, 
    ruta_imagen VARCHAR(255) NOT NULL COMMENT 'Parte final de la ruta en las carpetas del servidor HTTPS',
    
    INDEX accesorios_nombre(nombre), 
    INDEX accesorios_descuento(descuento), 
    INDEX accesorios_unidades_vendidas(unidades_vendidas)
); 

CREATE TABLE HISTORICO_CAMBIO_PRECIOS(
	id_registro_cambio INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    precio_asignado DECIMAL(12,2) NOT NULL COMMENT 'Nuevo precio asignado al artículo', 
    id_accesorio INT UNSIGNED NOT NULL, 
    
    CONSTRAINT fk_historico_cambio_precios_accesorios FOREIGN KEY (id_accesorio) REFERENCES ACCESORIOS(id_accesorio), 
    
    INDEX historico_cambio_precios_id_accesorio(id_accesorio)
); 

CREATE TABLE ORDENES_COMPRA(
	id_orden INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY, 
    fecha_compra TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	subtotal DECIMAL(12,2) NOT NULL, 
    descuento TINYINT UNSIGNED NOT NULL COMMENT 'Porcentaje actual de descuento', 
    impuestos DECIMAL(12,2) NOT NULL, 
    total DECIMAL(12,2) NOT NULL, 
    id_usuario INT UNSIGNED NOT NULL, 
    codigo_estado_compra INT UNSIGNED NOT NULL, 
    
    CONSTRAINT fk_ordenes_compra_usuarios FOREIGN KEY (id_usuario) REFERENCES USUARIOS(id_usuario), 
    CONSTRAINT fk_ordenes_compra_estado_compra FOREIGN KEY (codigo_estado_compra) REFERENCES TIPO_ESTADO_COMPRA(codigo_estado_compra), 
    
    INDEX ordenes_compra_id_orden(id_orden), 
    INDEX ordenes_compra_codigo_estado(codigo_estado_compra), 
    INDEX ordenes_compra_id_usuario(id_usuario), 
    INDEX ordenes_compra_fecha_compra(fecha_compra)
); 

CREATE TABLE ORDENES_COMPRA_HAS_ACCESORIOS(
	id_orden INT UNSIGNED NOT NULL, 
    id_accesorio INT UNSIGNED NOT NULL, 
    
    CONSTRAINT fk_ordenes_compra_has_accesorios_id_orden FOREIGN KEY (id_orden) REFERENCES ORDENES_COMPRA(id_orden), 
    CONSTRAINT fk_ordenes_compra_has_accesorios_id_accesorio FOREIGN KEY (id_accesorio) REFERENCES ACCESORIOS(id_accesorio), 
    
    INDEX ordenes_compra_has_accesorios_id_orden(id_orden), 
    INDEX ordenes_compra_has_accesorios_id_accesorio(id_accesorio)
); 

CREATE VIEW SESSION_USER_DATA AS
SELECT id_usuario, nombre, correo_electronico, contraseña, codigo_tipo_usuario, codigo_estado_cuenta
FROM USUARIOS; 


